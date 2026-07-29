import 'dart:convert';

import 'package:sm_network/sm_network.dart';
import 'package:sm_network_example/example.dart';
import 'package:sm_network_example/example_server.dart';

/// FormData will create readable "multipart/form-data" streams.
/// It can be used to submit forms and file uploads to http server.
void main() async {
  final server = await ExampleServer.start();
  configHttp(baseUrl: server.baseUri.toString());

  try {
    final data1 = await formData1();
    final data2 = await formData2();
    final bytes1 = await data1.readAsBytes();
    final bytes2 = await data2.readAsBytes();
    assert(bytes1.length == bytes2.length);

    final data3 = await formData3();
    print(utf8.decode(await data3.readAsBytes()));

    final uploadData = await formData3();
    final response = await Http.fetch<Map<String, dynamic>, Object?>(
      path: '/upload',
      method: Method.post,
      data: uploadData,
      onSendProgress: (sent, total) {
        if (total <= 0) {
          return;
        }
        print('percentage: ${(sent / total * 100).toStringAsFixed(0)}%');
      },
    );
    print(response.data);
  } finally {
    await server.close();
  }
}

Future<FormData> formData1() async {
  return FormData.fromMap({
    'name': 'wendux',
    'age': 25,
    'file': await MultipartFile.fromFile(
      '../assets/xx.png',
      filename: 'xx.png',
    ),
    'files': [
      await MultipartFile.fromFile(
        '../assets/upload.txt',
        filename: 'upload.txt',
      ),
      MultipartFile.fromFileSync(
        '../assets/upload.txt',
        filename: 'upload.txt',
      ),
    ],
  });
}

Future<FormData> formData2() async {
  final formData = FormData();

  formData.fields
    ..add(
      const MapEntry(
        'name',
        'wendux',
      ),
    )
    ..add(
      const MapEntry(
        'age',
        '25',
      ),
    );

  formData.files.add(
    MapEntry(
      'file',
      await MultipartFile.fromFile(
        '../assets/xx.png',
        filename: 'xx.png',
      ),
    ),
  );

  formData.files.addAll([
    MapEntry(
      'files',
      await MultipartFile.fromFile(
        '../assets/upload.txt',
        filename: 'upload.txt',
      ),
    ),
    MapEntry(
      'files',
      MultipartFile.fromFileSync(
        '../assets/upload.txt',
        filename: 'upload.txt',
      ),
    ),
  ]);
  return formData;
}

Future<FormData> formData3() async {
  return FormData.fromMap({
    'file': await MultipartFile.fromFile(
      '../assets/upload.txt',
      filename: 'uploadfile',
    ),
  });
}
