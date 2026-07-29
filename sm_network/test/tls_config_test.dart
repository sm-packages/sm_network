@TestOn('vm')
library;

import 'dart:io';

import 'package:sm_network/io.dart';
import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('keeps TLS certificate validation enabled by default', () {
    final client = _RecordingHttpClient();

    HttpOverrides.runZoned(
      () {
        Http.shared.config(
          httpClientOptions: HttpClientOptions(enable: true),
        );
        final adapter = Http.dio.httpClientAdapter as IOHttpClientAdapter;

        expect(adapter.createHttpClient!(), same(client));
      },
      createHttpClient: (_) => client,
    );

    expect(client.onBadCertificate, isNull);
  });
}

final class _RecordingHttpClient implements HttpClient {
  bool Function(X509Certificate, String, int)? onBadCertificate;

  @override
  set idleTimeout(Duration value) {}

  @override
  set badCertificateCallback(
    bool Function(X509Certificate cert, String host, int port)? callback,
  ) =>
      onBadCertificate = callback;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
