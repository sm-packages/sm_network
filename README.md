# sm_network

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

A Flutter networking library built on Dio.

## Features

- Dio-based HTTP requests
- Response conversion to `BaseResp<T>` and custom models
- Request, response, and error logs with cURL output
- Configurable request retries
- File upload and download
- HTTP/2 support
- Android and iOS system proxy integration

## Requirements

- Dart `>=3.5.4`
- Flutter `>=3.24.5`

## Installation

Run:

```shell
flutter pub add sm_network
```

Or add the dependency to `pubspec.yaml` and run `flutter pub get`:

```yaml
dependencies:
  sm_network: ^1.4.0
```

## Usage

Configure the shared client once, then make requests through `Http`:

```dart
import 'package:sm_network/sm_network.dart';

Future<void> main() async {
  await Http.shared.config(
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
