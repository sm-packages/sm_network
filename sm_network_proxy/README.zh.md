# sm_network_proxy

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

为 `sm_network` 提供可选的 Android 和 iOS 系统代理能力。该 package 与核心包
并列维护在 `sm_network` 仓库中，因此核心包可以保持为纯 Dart 包。

## 安装

```shell
flutter pub add sm_network_proxy
```

## 使用

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

使用 HTTP/2 时传入 `http2: true`：

```dart
final adapter = await SystemProxy.createAdapter(http2: true);
```
