@TestOn('vm')
library;

import 'package:sm_network/sm_network.dart';
import 'package:sm_network/src/utils/src/utils.dart';
import 'package:test/test.dart';

void main() {
  final utils = Utils.shared;

  test('processes request data when files are provided', () async {
    final files = {
      'file': await MultipartFile.fromFile(
        './assets/upload.txt',
        filename: 'upload.txt',
      ),
    };

    final result = utils.processRequestData(
      data: {'age': 25},
      files: files,
    );

    expect(result, isA<FormData>());
  });

  test('processes multipart data containing a file path', () async {
    final data = {
      'age': 25,
      'file': await MultipartFile.fromFile(
        './assets/upload.txt',
        filename: 'upload.txt',
      ),
    };

    final result = utils.processRequestData(
      data: data,
      contentType: ContentType.multipart,
    );

    expect(result, isA<FormData>());
  });
}
