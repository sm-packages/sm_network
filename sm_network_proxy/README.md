# sm_network_proxy

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

Optional Android and iOS system proxy support for `sm_network`. This package
is maintained alongside the core package in the `sm_network` repository, so
the core package can remain pure Dart.

## Installation

```shell
flutter pub add sm_network_proxy
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

Pass `http2: true` when the client uses HTTP/2:

```dart
final adapter = await SystemProxy.createAdapter(http2: true);
```
