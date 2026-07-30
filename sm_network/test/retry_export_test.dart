import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

bool _retryIf(Exception error, int attempt) => true;

void main() {
  test('keeps retry types available from sm_network', () {
    const options = RetryOptions(maxAttempts: 2);
    const RetryFunction<bool> retryIf = _retryIf;

    expect(options.maxAttempts, 2);
    expect(retryIf(Exception(), 1), true);
  });
}
