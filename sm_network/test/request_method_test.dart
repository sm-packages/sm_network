@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:sm_network/sm_network.dart';
import 'package:test/test.dart';

void main() {
  test('forwards convenience request methods to Dio', () async {
    final methods = <String>[];
    final adapter = _RecordingAdapter(methods);
    Http.shared.config(
      options: HttpBaseOptions(baseUrl: 'https://example.com'),
      httpClientAdapter: adapter,
    );

    await Http.post<Object?>(path: '/post');
    await Http.put<Object?>(path: '/put');
    await Http.patch<Object?>(path: '/patch');
    await Http.delete<Object?>(path: '/delete');
    await Http.head<Object?>(path: '/head');
    await Http.upload<Object?>(
      path: '/upload',
      files: {
        'file': MultipartFile.fromBytes([1], filename: 'one.bin'),
      },
    );
    await Http.post<Object?>(
      path: '/retry-post',
      retryOptions: const HttpRetryOptions(retryCount: 1),
    );

    final directory = await Directory.systemTemp.createTemp('sm_network_test_');
    final file = File('${directory.path}/download.txt');

    try {
      await Http.download(path: '/download', savePath: file.path);

      expect(await file.readAsString(), contains('"code":200'));
    } finally {
      await directory.delete(recursive: true);
    }

    expect(
      methods,
      ['POST', 'PUT', 'PATCH', 'DELETE', 'HEAD', 'POST', 'POST', 'GET'],
    );
  });
}

final class _RecordingAdapter implements HttpClientAdapter {
  _RecordingAdapter(this.methods);

  final List<String> methods;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    methods.add(options.method);
    return ResponseBody.fromString(
      jsonEncode({
        'code': 200,
        'data': {'ok': true},
        'message': 'OK',
      }),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
