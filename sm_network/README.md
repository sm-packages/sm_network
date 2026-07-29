# sm_network

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

A Dart networking library built on Dio, usable from Dart and Flutter apps.

See [`example/`](example/) for command-line usage and the
[Flutter example](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy/example)
for Flutter integration.

## Features

- Dio-based HTTP requests
- Response conversion to `BaseResp<T>` and custom models
- Request, response, and error logs with cURL output
- Configurable request retries
- File upload and download
- HTTP/2 support
- Optional Android and iOS system proxy extension

## Requirements

- Dart `>=3.5.4`

## Installation

For Dart projects, run:

```shell
dart pub add sm_network
```

For Flutter projects, run:

```shell
flutter pub add sm_network
```

Or add the dependency to `pubspec.yaml` and run `dart pub get` or
`flutter pub get`:

```yaml
dependencies:
  sm_network: ^1.4.0
```

## Usage

### Setup

Configure the shared client once when the application starts:

```dart
import 'package:sm_network/sm_network.dart';

void main() {
  Http.shared.config(
    options: HttpBaseOptions(
      baseUrl: 'https://api.example.com',
      log: const HttpLog(
        options: LogOptions(
          enable: true,
          responseData: true,
          curl: true,
        ),
      ),
      retryOptions: const HttpRetryOptions(retryCount: 2),
    ),
  );
}
```

Existing Dio configuration can also be injected through `dio:`, `interceptors:`,
`httpClientAdapter:`, and `transformer:`.

### Requests

Convenience methods return `BaseResp<T>`. The default response envelope is:

```json
{
  "code": 200,
  "data": {},
  "message": "OK"
}
```

```dart
final profile = await Http.get<Map<String, dynamic>>(
  path: '/profile',
  queryParameters: {'expand': 'roles'},
);

final created = await Http.post<Map<String, dynamic>>(
  path: '/users',
  data: {'name': 'Shay'},
);

if (!created.isSuccess) {
  throw StateError(created.message ?? 'Request failed');
}
```

The package provides `get`, `post`, `put`, `patch`, `delete`, and `head`, plus
corresponding Uri variants such as `getUri` and `postUri`. Use `fetch` when the
raw Dio `Response` is required:

```dart
final response = await Http.fetch<Map<String, dynamic>, Object?>(
  path: '/health',
  method: Method.get,
);

print(response.statusCode);
print(response.data);
```

### Data To Models

Pass a model's `fromJson` function to `Http.session<T>`. When the response
`data` is an object, the converted value is in `response.data`. When it is an
array, converted values are in `response.list`.

```dart
final class User {
  const User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  final int id;
  final String name;
}

final userResponse = await Http.session<User>(
  path: '/users/1',
  fromJsonT: User.fromJson,
).get();

final user = userResponse.data;

final usersResponse = await Http.session<User>(
  path: '/users',
  fromJsonT: User.fromJson,
).get();

final users = usersResponse.list;
```

Configure field paths when the server uses a different envelope. Nested paths
are supported:

```dart
Http.shared.config(
  options: HttpBaseOptions(
    baseUrl: 'https://api.example.com',
    converterOptions: DefaultConverterOptions(
      code: 'meta.code',
      data: 'payload',
      message: 'meta.message',
      status: (code, response) => code == 0,
    ),
  ),
);
```

For complex or repeated requests, extend `Session<T>` and keep the path,
method, parameters, and `fromJsonT` together. See `PostSession` in the Flutter
example for a complete implementation.

### Retry And Cancellation

`retryCount` is the number of additional attempts after the first failure:

```dart
final cancelToken = CancelToken();

final request = Http.get<Map<String, dynamic>>(
  path: '/profile',
  cancelToken: cancelToken,
  retryOptions: HttpRetryOptions(
    retryCount: 2,
    retryIf: (error, attempt) =>
        error is DioException && error.type != DioExceptionType.cancel,
    onRetry: (error, attempt) {
      print('retry $attempt: $error');
    },
  ),
);

// Call this when the page is disposed or the result is no longer needed.
cancelToken.cancel('request is no longer needed');
final response = await request;
```

### Uploads And Downloads

```dart
final upload = await Http.upload<Map<String, dynamic>>(
  path: '/files',
  fields: {'type': 'avatar'},
  files: {
    'file': await MultipartFile.fromFile(
      'avatar.png',
      filename: 'avatar.png',
    ),
  },
  onSendProgress: (sent, total) {
    print('$sent / $total');
  },
);

final download = await Http.download(
  path: '/files/report.pdf',
  savePath: 'report.pdf',
  onReceiveProgress: (received, total) {
    print('$received / $total');
  },
);
```

Use `MultipartFile.fromBytes` for browser uploads. File-path uploads and
downloads are available only on `dart:io` platforms.

### HTTP/2 And Certificates

HTTP/2 and custom certificate configuration are available only on `dart:io`
platforms:

```dart
Http.shared.config(
  options: HttpBaseOptions(baseUrl: 'https://api.example.com'),
  httpClientOptions: HttpClientOptions(
    enable: true,
    h2: true,
  ),
);
```

System certificate validation is used by default. Leaf-certificate pinning is
enabled only when `pem` is supplied explicitly:

```dart
import 'dart:io';

Future<void> main() async {
  final serverCertificatePem = await File('server.pem').readAsString();

  Http.shared.config(
    options: HttpBaseOptions(baseUrl: 'https://api.example.com'),
    httpClientOptions: HttpClientOptions(
      enable: true,
      pem: serverCertificatePem,
    ),
  );
}
```

`pKCSPath` loads custom trusted certificates. iOS accepts one DER X.509
certificate; other I/O platforms accept PEM or PKCS12.

### Web

Normal requests, response conversion, logging, and retries work on Web. Web
does not support `HttpClientOptions`, the HTTP/2 I/O adapter, system proxy
discovery, or file-path I/O. Enabling `HttpClientOptions` throws an
`UnsupportedError`.

## Examples

[`example/`](example/) contains runnable command-line examples for:

- Raw requests and data-to-model conversion
- FormData and file uploads
- Downloads, progress, and cancellation
- Custom Dio adapters

## Proxy Extensions

The core package has no Flutter dependency. Flutter apps that need Android or
iOS system proxy discovery can install the optional
[`sm_network_proxy`](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy)
plugin maintained in this repository:

```shell
flutter pub add sm_network sm_network_proxy
```

Then inject the adapter produced by the plugin:

```dart
import 'package:flutter/widgets.dart';
import 'package:sm_network/sm_network.dart';
import 'package:sm_network_proxy/sm_network_proxy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Http.shared.config(
    httpClientAdapter: await SystemProxy.createAdapter(),
  );
}
```

For HTTP/2, pass `http2: true` to `createAdapter()`.
