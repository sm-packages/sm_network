import 'dart:io';

import 'package:sm_network/io.dart';
import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('config accepts proxy behavior through an injected adapter', () {
    String findProxy(Uri _) => 'PROXY 127.0.0.1:8080';
    final client = HttpClient()..findProxy = findProxy;
    final adapter = IOHttpClientAdapter(createHttpClient: () => client);

    Http.shared.config(httpClientAdapter: adapter);

    expect(Http.dio.httpClientAdapter, same(adapter));
    expect(
      findProxy(Uri.https('example.com', '/')),
      'PROXY 127.0.0.1:8080',
    );
    client.close(force: true);
  });
}
