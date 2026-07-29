import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:sm_network_example/example.dart';
import 'package:sm_network_example/example_server.dart';
import 'package:sm_network/sm_network.dart';

// In this example we download a image and listen the downloading progress.
void main() async {
  final server = await ExampleServer.start();
  configHttp(headers: {
    // Assure the value of total argument of onReceiveProgress is not -1.
    'accept-encoding': '*',
  });

  try {
    await Directory('./download').create(recursive: true);

    final url = server.baseUri.resolve('download').toString();
    await download1(url, './download/example.svg');
    await download1(url, (headers) => './download/example-1.svg');
    await download1(url, (headers) async => './download/example-2.svg');
    // await download2(url, './download/example-3.svg');
  } finally {
    await server.close();
  }
}

Future download1(String url, savePath) async {
  final cancelToken = CancelToken();
  try {
    final resp = await Http.download(
      path: url,
      savePath: savePath,
      onReceiveProgress: showDownloadProgress,
      cancelToken: cancelToken,
    );
    print(resp);
  } catch (e) {
    print(e);
  }
}

//Another way to downloading small file
Future download2(String url, String savePath) async {
  try {
    final response = await Http.get<Uint8List>(
      path: url,
      onReceiveProgress: showDownloadProgress,
      //Received data with List<int>
      options: HttpOptions(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: Duration.zero,
      ),
    );
    // print(response.data?.headers);
    final file = File(savePath);
    final raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    if (response.data != null) {
      raf.writeFromSync(response.data!);
    }
    await raf.close();
  } catch (e) {
    print(e);
  }
}

void showDownloadProgress(int received, int total) {
  if (total <= 0) {
    return;
  }
  print('percentage: ${(received / total * 100).toStringAsFixed(0)}%');
}
