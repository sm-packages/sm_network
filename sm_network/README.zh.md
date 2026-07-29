# sm_network

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

一个基于 Dio 的 Dart 网络请求库，可用于 Dart 和 Flutter 应用。

命令行用法见 [`example/`](example/)，Flutter 集成见
[Flutter 示例](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy/example)。

## 特性

- 基于 Dio 的 HTTP 请求
- 将响应转换为 `BaseResp<T>` 和自定义模型
- 请求、响应和错误日志，支持输出 cURL
- 可配置的请求重试
- 文件上传和下载
- HTTP/2 支持
- 可选的 Android 和 iOS 系统代理扩展

## 环境要求

- Dart `>=3.5.4`

## 安装

在 Dart 项目中运行：

```shell
dart pub add sm_network
```

在 Flutter 项目中运行：

```shell
flutter pub add sm_network
```

或者在 `pubspec.yaml` 中添加依赖，然后运行 `dart pub get` 或
`flutter pub get`：

```yaml
dependencies:
  sm_network: ^1.4.0
```

## 使用

先配置一次共享客户端，然后通过 `Http` 发起请求：

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

## 代理扩展

核心包不依赖 Flutter。Flutter 应用需要读取 Android 或 iOS 系统代理时，
可以安装同仓库维护的可选插件
[`sm_network_proxy`](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy)：

```shell
flutter pub add sm_network_proxy
```

然后注入插件创建的 adapter：

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

使用 HTTP/2 时，向 `createAdapter()` 传入 `http2: true`。
