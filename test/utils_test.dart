// ignore_for_file: avoid_redundant_argument_values, avoid_print

import 'package:flutter_test/flutter_test.dart';
import 'package:sm_network/sm_network.dart';
import 'package:sm_network/src/utils/src/utils.dart';

void main() {
  final utils = Utils.shared;
  Object? data;
  FormFiles? files;

  test(
    'test process data when files is not null',
    () async {
      data = {'age': 25};
      files = {
        'file': await MultipartFile.fromFile(
          './assets/upload.txt',
          filename: 'upload.txt',
        ),
      };
      final result = utils.processRequestData(
        data: data,
        files: files,
      );
      expect(result, isA<FormData>());
    },
  );

  test(
    'test process data when data is not null',
    () async {
      data = {
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
    },
  );

  test(
    'test process request data',
    () {
      (dynamic, String?) processDate(
        dynamic data,
        ContentType? contentType, {
        bool isCurl = false,
      }) =>
          utils.processLogRequestData(
            data,
            contentType,
            ([tabCount = 1]) => ' ' * tabCount,
            isCurl: isCurl,
          );

      const text = 'Hello World';
      const map = {'name': 'Shay', 'age': 18};
      const json = '''
{
  "name": "Shay",
  "age": 18
 }''';
      final formData = FormData.fromMap(map);
      final formFileds = utils.mergeListToMap(formData.fields);
      final formFiledsString = [
        ' --form \'name="Shay"\'',
        ' --form \'age="18"\'',
      ];
      final Iterable<String> formUrlencodedString = [
        " --data-urlencode 'name=Shay'",
        " --data-urlencode 'age=18'",
      ];

      (dynamic, String?) result;

      result = processDate(text, ContentType.raw, isCurl: false);
      expect(result.$1, text);
      expect(result.$2, 'Request Text Plain');

      result = processDate(text, ContentType.raw, isCurl: true);
      expect(result.$1, text);
      expect(result.$2, null);

      result = processDate(map, ContentType.json, isCurl: false);
      expect(result.$1, map);
      expect(result.$2, 'Request Json');

      result = processDate(map, ContentType.json, isCurl: true);
      expect(result.$1, json);
      expect(result.$2, null);

      result = processDate(formData, ContentType.multipart, isCurl: false);
      expect(result.$1, formFileds);
      expect(result.$2, 'Request Form Data');

      result = processDate(formData, ContentType.multipart, isCurl: true);
      expect(result.$1, formFiledsString);
      expect(result.$2, null);

      result = processDate(map, ContentType.urlencoded, isCurl: false);
      expect(result.$1, map);
      expect(result.$2, 'Request Form Urlencoded');

      result = processDate(map, ContentType.urlencoded, isCurl: true);
      expect(result.$1, formUrlencodedString);
      expect(result.$2, null);
    },
  );
}
