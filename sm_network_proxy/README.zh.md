# sm_network_proxy

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

为 `sm_network` 提供可选的 Android 和 iOS 系统代理能力。该 package 与核心包
并列维护在 `sm_network` 仓库中，因此核心包可以保持为纯 Dart 包。

## 安装

```shell
flutter pub add sm_network sm_network_proxy
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

`createAdapter()` 每次都会读取当前系统代理。未配置系统代理或代理值无效时，
返回的 adapter 使用直连。

### HTTP/2

使用 HTTP/2 时传入 `http2: true`：

```dart
final adapter = await SystemProxy.createAdapter(http2: true);
```

如果应用运行期间系统代理发生变化，请重新读取并替换 adapter：

```dart
Http.dio.httpClientAdapter = await SystemProxy.createAdapter();
```

### 平台

- Android：读取 Java 系统 HTTP 代理属性。
- iOS：读取系统代理配置。
- 其他平台：该插件不提供实现；直接使用核心包的 adapter 配置。

## 示例

Flutter 示例同时展示系统代理、`Session<Person>` 和响应模型转换：

```shell
cd example
flutter pub get
flutter run
```
