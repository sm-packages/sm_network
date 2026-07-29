import 'dart:convert';
import 'dart:io';

final class ExampleServer {
  ExampleServer._(this._server) {
    _server.listen(_handleRequest);
  }

  final HttpServer _server;

  static Future<ExampleServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    return ExampleServer._(server);
  }

  Uri get baseUri => Uri(
        scheme: 'http',
        host: _server.address.address,
        port: _server.port,
        path: '/',
      );

  Future<void> close() => _server.close(force: true);

  Future<void> _handleRequest(HttpRequest request) async {
    await request.drain<void>();

    if (request.uri.path == '/download') {
      final bytes = utf8.encode(
          '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"/>');
      request.response
        ..headers.contentType =
            ContentType('image', 'svg+xml', charset: 'utf-8')
        ..contentLength = bytes.length
        ..add(bytes);
      await request.response.close();
      return;
    }

    final data = switch (request.uri.path) {
      '/model' => {'id': 1, 'name': 'Shay'},
      '/models' => [
          {'id': 1, 'name': 'Shay'},
          {'id': 2, 'name': 'Alex'},
        ],
      '/upload' => {'uploaded': true},
      _ => {
          'method': request.method,
          'path': request.uri.path,
          'query': request.uri.queryParameters,
        },
    };

    request.response
      ..headers.contentType = ContentType.json
      ..write(
        jsonEncode({
          'code': 200,
          'data': data,
          'message': 'OK',
        }),
      );
    await request.response.close();
  }
}
