import 'dart:io' as io;

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';

import 'options/src/http_client_options.dart';

/// Configures Dio's I/O or HTTP/2 adapter.
void configureHttpClientAdapter(Dio dio, HttpClientOptions options) {
  final ioAdapter = _createIoAdapter(options);

  if (options.h2) {
    dio.httpClientAdapter = Http2Adapter(
      ConnectionManager(
        idleTimeout: const Duration(seconds: 10),
        onClientCreate: (_, config) {
          config.context = _createSecurityContext(options);
          if (options.pem case final pem?) {
            config.onBadCertificate = (certificate) => certificate.pem == pem;
            config.validateCertificate = (certificate, host, port) => certificate?.pem == pem;
          }
        },
      ),
      fallbackAdapter: ioAdapter,
    );
  } else if (dio.httpClientAdapter is IOHttpClientAdapter) {
    dio.httpClientAdapter = ioAdapter;
  }
}

IOHttpClientAdapter _createIoAdapter(HttpClientOptions options) {
  final pem = options.pem;
  return IOHttpClientAdapter(
    createHttpClient: () {
      final client = io.HttpClient(
        context: _createSecurityContext(options),
      )..idleTimeout = const Duration(seconds: 15);
      if (pem != null) {
        client.badCertificateCallback = (certificate, host, port) => certificate.pem == pem;
      }
      return client;
    },
    validateCertificate: pem == null ? null : (certificate, host, port) => certificate?.pem == pem,
  );
}

io.SecurityContext? _createSecurityContext(HttpClientOptions options) {
  final path = options.pKCSPath;
  if (path == null) {
    return null;
  }

  return io.SecurityContext()..setTrustedCertificates(path, password: options.pKCSPwd);
}
