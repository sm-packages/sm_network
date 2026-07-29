@TestOn('browser')
library;

import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('rejects I/O-only client options on web', () {
    expect(
      () => Http.shared.config(
        httpClientOptions: HttpClientOptions(enable: true, h2: true),
      ),
      throwsUnsupportedError,
    );
  });
}
