import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('parses content types with parameters on every platform', () {
    expect(ContentType.tryParse('text/plain; charset=utf-8'), ContentType.raw);
    expect(ContentType.tryParse('application/json; charset=utf-8'), ContentType.json);
    expect(
      ContentType.tryParse('multipart/form-data; boundary=example'),
      ContentType.multipart,
    );
  });
}
