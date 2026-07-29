import 'dart:io';

import 'package:sm_network/io.dart';
import 'package:sm_network_example/example.dart';
import 'package:sm_network_example/example_server.dart';

Future<void> main() async {
  final server = await ExampleServer.start();
  configHttp(
    baseUrl: server.baseUri.toString(),
    httpClientAdapter: IOHttpClientAdapter(
      createHttpClient: () =>
          HttpClient()..idleTimeout = const Duration(seconds: 15),
    ),
  );

  try {
    await rawGet();
  } finally {
    await server.close();
  }
}
