// ignore_for_file: close_sinks, cancel_subscriptions

import 'dart:async';
import 'dart:convert' show ascii;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart' show ClientSetting, ConnectionManager;
import 'package:http2/http2.dart';

/// Default implementation of ConnectionManager
class ConnectionManagerImpl implements ConnectionManager {
  /// Constructor
  ConnectionManagerImpl({
    int? idleTimeout,
    this.onClientCreate,
    this.proxyHost,
    this.proxyPort,
  }) : _idleTimeout = idleTimeout ?? 1000;

  /// Callback when socket created.
  ///
  /// We can set trusted certificates and handler
  /// for unverifiable certificates.
  final void Function(Uri uri, ClientSetting)? onClientCreate;

  /// Sets the idle timeout(milliseconds) of non-active persistent
  /// connections. For the sake of socket reuse feature with http/2,
  /// the value should not be less than 1000 (1s).
  final int _idleTimeout;

  /// Proxy host
  final String? proxyHost;

  /// Proxy port
  final int? proxyPort;

  /// Saving the reusable connections
  final _transportsMap = <String, _ClientTransportConnectionState>{};

  /// Saving the connecting futures
  final _connectFutures = <String, Future<_ClientTransportConnectionState>>{};

  bool _closed = false;
  bool _forceClosed = false;

  @override
  void close({bool force = false}) {
    _closed = true;
    _forceClosed = force;
    if (force) {
      _transportsMap.forEach((key, value) => value.dispose());
    }
  }

  /// https://www.ietf.org/rfc/rfc2817.txt
  Future<ClientTransportConnection> connectTunnel(
    RequestOptions options,
    String proxyHost,
    int proxyPort,
  ) async {
    final uri = options.uri;
    final clientConfig = ClientSetting();
    if (onClientCreate != null) {
      onClientCreate!.call(uri, clientConfig);
    }
    SecureSocket socket;
    try {
      final proxy = await Socket.connect(
        proxyHost,
        proxyPort,
        timeout: options.connectTimeout,
      );
      // ignore: constant_identifier_names
      const String CRLF = '\r\n';
      proxy.write('CONNECT ${uri.host}:${uri.port} HTTP/1.1'); // request line
      proxy.write(CRLF);
      proxy.write('Host: ${uri.host}:${uri.port}'); // header
      proxy.write(CRLF);
      proxy.write(CRLF);
      final completer = Completer<bool>.sync();
      final sub = proxy.listen(
        (event) {
          final response = ascii.decode(event);
          final lines = response.split(CRLF);
          // status line
          final statusLine = lines.first;
          if (statusLine.startsWith('HTTP/1.1 200')) {
            completer.complete(true);
          } else {
            completer.completeError(statusLine);
          }
        },
        onError: completer.completeError,
      );
      await completer.future; // established
      sub.pause();
      socket = await SecureSocket.secure(
        proxy,
        host: uri.host,
        context: clientConfig.context,
        onBadCertificate: clientConfig.onBadCertificate,
        supportedProtocols: const ['h2'],
      );
    } on SocketException catch (e) {
      if (e.osError == null) {
        if (e.message.contains('timed out')) {
          throw DioException(
            requestOptions: options,
            error: 'Connecting timed out [${options.connectTimeout}ms]',
            type: DioExceptionType.connectionTimeout,
          );
        }
      }
      rethrow;
    }
    return ClientTransportConnection.viaSocket(socket);
  }

  @override
  Future<ClientTransportConnection> getConnection(
    RequestOptions options,
    List<RedirectRecord> redirects,
  ) async {
    if (_closed) {
      throw Exception("Can't establish connection after [ConnectionManager] closed!");
    }
    final uri = options.uri;
    final domain = '${uri.host}:${uri.port}';
    var transportState = _transportsMap[domain];
    if (transportState == null) {
      var initFuture = _connectFutures[domain];
      if (initFuture == null) {
        _connectFutures[domain] = initFuture = _connect(options);
      }
      transportState = await initFuture;
      if (_forceClosed) {
        transportState.dispose();
      } else {
        _transportsMap[domain] = transportState;
        final _ = _connectFutures.remove(domain);
      }
    } else {
      // Check whether the connection is terminated, if it is, reconnecting.
      if (!transportState.transport.isOpen) {
        transportState.dispose();
        _transportsMap[domain] = transportState = await _connect(options);
      }
    }
    return transportState.activeTransport;
  }

  @override
  void removeConnection(ClientTransportConnection transport) {
    _ClientTransportConnectionState? transportState;
    _transportsMap.removeWhere((_, state) {
      if (state.transport == transport) {
        transportState = state;
        return true;
      }
      return false;
    });
    transportState?.dispose();
  }

  // TODO(shay):  应该根据host port 证书等进行连接池复用;dio原有的DefaultHttpClientAdapter也没做这方面处理
  Future<_ClientTransportConnectionState> _connect(RequestOptions options) async {
    final uri = options.uri;
    final domain = '${uri.host}:${uri.port}';
    ClientTransportConnection transport;
    if ((proxyHost?.isNotEmpty ?? false) && proxyPort != null) {
      transport = await connectTunnel(options, proxyHost!, proxyPort!);
    } else {
      final clientConfig = ClientSetting();
      if (onClientCreate != null) {
        onClientCreate!.call(uri, clientConfig);
      }
      SecureSocket socket;
      try {
        // Create socket
        socket = await SecureSocket.connect(
          uri.host,
          uri.port,
          timeout: options.connectTimeout,
          context: clientConfig.context,
          onBadCertificate: clientConfig.onBadCertificate,
          supportedProtocols: ['h2'],
        );
      } on SocketException catch (e) {
        if (e.osError == null) {
          if (e.message.contains('timed out')) {
            throw DioException(
              requestOptions: options,
              error: 'Connecting timed out [${options.connectTimeout}ms]',
              type: DioExceptionType.connectionTimeout,
            );
          }
        }
        rethrow;
      }
      // Config a ClientTransportConnection and save it
      transport = ClientTransportConnection.viaSocket(socket);
    }
    final transportState = _ClientTransportConnectionState(transport);
    transport.onActiveStateChanged = (bool isActive) {
      transportState.isActive = isActive;
      if (!isActive) {
        transportState.latestIdleTimeStamp = DateTime.now().millisecondsSinceEpoch;
      }
    };
    //
    transportState.delayClose(
      _closed ? 50 : _idleTimeout,
      () {
        _transportsMap.remove(domain);
        transportState.transport.finish();
      },
    );
    return transportState;
  }
}

class _ClientTransportConnectionState {
  _ClientTransportConnectionState(this.transport);

  ClientTransportConnection transport;

  bool isActive = true;

  late int latestIdleTimeStamp;
  Timer? _timer;
  ClientTransportConnection get activeTransport {
    isActive = true;
    latestIdleTimeStamp = DateTime.now().millisecondsSinceEpoch;
    return transport;
  }

  void delayClose(int idleTimeout, void Function() callback) {
    idleTimeout = idleTimeout < 100 ? 100 : idleTimeout;
    _startTimer(callback, idleTimeout, idleTimeout);
  }

  void dispose() {
    _timer?.cancel();
    transport.finish();
  }

  void _startTimer(void Function() callback, int duration, int idleTimeout) {
    _timer = Timer(Duration(milliseconds: duration), () {
      if (!isActive) {
        final interval = DateTime.now().millisecondsSinceEpoch - latestIdleTimeStamp;
        if (interval >= duration) {
          return callback();
        }
        return _startTimer(callback, duration - interval, idleTimeout);
      }
      // if active
      _startTimer(callback, idleTimeout, idleTimeout);
    });
  }
}
