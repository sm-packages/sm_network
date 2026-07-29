@TestOn('vm')
library;

import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('config keeps HTTP/2 support in the core package', () {
    Http.shared.config(
      httpClientOptions: HttpClientOptions(enable: true, h2: true),
    );

    expect(Http.dio.httpClientAdapter, isA<Http2Adapter>());
  });
}
