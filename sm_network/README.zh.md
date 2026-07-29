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

### 初始化

应用启动时配置一次共享客户端：

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

也可以通过 `dio:`、`interceptors:`、`httpClientAdapter:` 和 `transformer:`
注入已有的 Dio 配置。

### 常用请求

快捷方法返回 `BaseResp<T>`。默认响应结构为：

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

同时提供 `get`、`post`、`put`、`patch`、`delete`、`head` 及对应的
`getUri`、`postUri` 等 Uri 版本。需要 Dio 原始 `Response` 时使用 `fetch`：

```dart
final response = await Http.fetch<Map<String, dynamic>, Object?>(
  path: '/health',
  method: Method.get,
);

print(response.statusCode);
print(response.data);
```

### Data 转 Model

为 `Http.session<T>` 提供模型的 `fromJson` 函数。响应的 `data` 是对象时，
结果位于 `response.data`；`data` 是数组时，结果位于 `response.list`。

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

如果服务端 envelope 字段不同，可在初始化时指定字段路径；路径支持嵌套字段：

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

复杂或重复请求可以继承 `Session<T>`，集中声明路径、方法、参数和
`fromJsonT`。完整示例见 Flutter 示例中的 `PostSession`。

### 重试与取消

`retryCount` 表示失败后的额外重试次数：

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

// 页面销毁或请求不再需要时调用。
cancelToken.cancel('request is no longer needed');
final response = await request;
```

### 上传与下载

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

浏览器上传请使用 `MultipartFile.fromBytes`；文件路径上传和下载仅适用于
`dart:io` 平台。

### HTTP/2 与证书

HTTP/2 和自定义证书配置仅适用于 `dart:io` 平台：

```dart
Http.shared.config(
  options: HttpBaseOptions(baseUrl: 'https://api.example.com'),
  httpClientOptions: HttpClientOptions(
    enable: true,
    h2: true,
  ),
);
```

默认使用系统证书校验。只有显式提供 `pem` 时才启用叶证书固定：

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

`pKCSPath` 可加载自定义信任证书。iOS 仅支持单个 DER X.509 证书；
其他 I/O 平台支持 PEM 或 PKCS12。

### Web

普通请求、响应转换、日志和重试可在 Web 使用。Web 不支持
`HttpClientOptions`、HTTP/2 I/O adapter、系统代理和文件路径读写；启用
`HttpClientOptions` 时会抛出 `UnsupportedError`。

## 示例

[`example/`](example/) 提供可运行的命令行示例：

- 原始请求与 Data 转 Model
- FormData 和文件上传
- 下载、进度和取消
- 自定义 Dio adapter

## 代理扩展

核心包不依赖 Flutter。Flutter 应用需要读取 Android 或 iOS 系统代理时，
可以安装同仓库维护的可选插件
[`sm_network_proxy`](https://github.com/sm-packages/sm_network/tree/main/sm_network_proxy)：

```shell
flutter pub add sm_network sm_network_proxy
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
