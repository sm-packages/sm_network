# sm_network

| [English](README.md) | [简体中文](README.zh.md) |
| -------------------- | ----------------------- |

一个基于 Dio 的 Flutter 网络请求库。

## 特性

- 基于 Dio 的 HTTP 请求
- 将响应转换为 `BaseResp<T>` 和自定义模型
- 请求、响应和错误日志，支持输出 cURL
- 可配置的请求重试
- 文件上传和下载
- HTTP/2 支持
- Android 和 iOS 系统代理集成

## 环境要求

- Dart `>=3.5.4`
- Flutter `>=3.24.5`

## 安装

运行：

```shell
flutter pub add sm_network
```

或者在 `pubspec.yaml` 中添加依赖，然后运行 `flutter pub get`：

```yaml
dependencies:
  sm_network: ^1.4.0
```

## 使用

先配置一次共享客户端，然后通过 `Http` 发起请求：

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
