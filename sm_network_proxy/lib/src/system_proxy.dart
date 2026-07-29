import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Creates Dio adapters that use the Android or iOS system HTTP proxy.
final class SystemProxy {
  const SystemProxy._();

  static const _channel = MethodChannel('sm_network/proxy');

  /// Returns the current system HTTP proxy as `host:port`.
  static Future<String?> getProxy() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return null;
    }
    return _channel.invokeMethod<String>('getProxy');
  }

  /// Creates a Dio adapter configured with the current system proxy.
  static Future<HttpClientAdapter> createAdapter({bool http2 = false}) async {
    final proxy = _parseProxy(await getProxy());
    final fallbackAdapter = _createIoAdapter(proxy);

    if (http2) {
      return Http2Adapter(
        ConnectionManager(
          onClientCreate: (_, settings) => settings.proxy = proxy,
        ),
        fallbackAdapter: fallbackAdapter,
      );
    }

    return fallbackAdapter;
  }

  static IOHttpClientAdapter _createIoAdapter(Uri? proxy) {
    final authority = proxy == null ? null : Uri(host: proxy.host, port: proxy.port).authority;
    final directive = authority == null ? 'DIRECT' : 'PROXY $authority';
    return IOHttpClientAdapter(
      createHttpClient: () => HttpClient()..findProxy = (_) => directive,
    );
  }

  static Uri? _parseProxy(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final separator = value.lastIndexOf(':');
    if (separator <= 0 || separator == value.length - 1) {
      return null;
    }

    var host = value.substring(0, separator).trim();
    if (host.startsWith('[') && host.endsWith(']')) {
      host = host.substring(1, host.length - 1);
    }
    final port = int.tryParse(value.substring(separator + 1));
    if (host.isEmpty || port == null || port < 1 || port > 65535) {
      return null;
    }

    try {
      return Uri(scheme: 'http', host: host, port: port);
    } on FormatException {
      return null;
    }
  }
}
