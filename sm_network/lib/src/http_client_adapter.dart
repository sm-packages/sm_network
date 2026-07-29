import 'package:dio/dio.dart';

import 'options/src/http_client_options.dart';

/// Rejects I/O-only client options on unsupported platforms.
void configureHttpClientAdapter(Dio dio, HttpClientOptions options) {
  throw UnsupportedError(
    'HttpClientOptions is only supported on dart:io platforms.',
  );
}
