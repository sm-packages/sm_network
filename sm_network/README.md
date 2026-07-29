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

Configure the shared client once, then make requests through `Http`:

```dart
import 'package:sm_network/sm_network.dart';

Future<void> main() async {
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

  final response = await Http.get<Map<String, dynamic>>(
    path: '/profile',
  );

  if (!response.isSuccess) {
    throw StateError(response.message ?? 'Request failed');
  }

  print(response.data);
}
```

## Proxy Extensions

The core package has no Flutter dependency. Flutter apps that need Android or
iOS system proxy discovery can install the optional
[`sm_network_proxy`](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy)
plugin maintained in this repository:

```shell
flutter pub add sm_network_proxy
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
