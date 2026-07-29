# sm_network_proxy

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

Optional Android and iOS system proxy support for `sm_network`. This package
is maintained alongside the core package in the `sm_network` repository, so
the core package can remain pure Dart.

## Installation

```shell
flutter pub add sm_network sm_network_proxy
```

## Usage

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

Each `createAdapter()` call reads the current system proxy. If no valid system
proxy is configured, the returned adapter connects directly.

### HTTP/2

Pass `http2: true` when the client uses HTTP/2:

```dart
final adapter = await SystemProxy.createAdapter(http2: true);
```

If the system proxy changes while the app is running, read it again and replace
the adapter:

```dart
Http.dio.httpClientAdapter = await SystemProxy.createAdapter();
```

### Platforms

- Android reads the Java system HTTP proxy properties.
- iOS reads the system proxy configuration.
- Other platforms are not implemented by this plugin; configure a core
  package adapter directly instead.

## Example

The Flutter example combines the system proxy with `Session<Person>` response
conversion:

```shell
cd example
flutter pub get
flutter run
```
