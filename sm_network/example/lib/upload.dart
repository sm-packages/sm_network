import 'package:sm_network/sm_network.dart';
import 'package:sm_network_example/example.dart';
import 'package:sm_network_example/example_server.dart';

Future<void> main(List<String> args) async {
  final server = await ExampleServer.start();
  configHttp(baseUrl: server.baseUri.toString());

  final fields = {'age': 25};

  final files = {
    'file': await MultipartFile.fromFile(
      '../assets/upload.txt',
      filename: 'upload.txt',
    ),
  };

  try {
    final response = await Http.upload<Map<String, dynamic>>(
      path: '/upload',
      fields: fields,
      files: files,
      onSendProgress: (sent, total) {
        print('sent: $sent, total: $total');
      },
    );

    print(response);
  } finally {
    await server.close();
  }
}
