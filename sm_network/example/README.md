# sm_network examples

Run the examples from this directory:

```shell
dart pub get
dart run lib/example.dart
```

| File | Demonstrates |
| --- | --- |
| `lib/example.dart` | Raw Dio responses, interceptors, single-model conversion, and list conversion |
| `lib/formdata.dart` | Building multipart `FormData` manually and upload progress |
| `lib/upload.dart` | `Http.upload`, form fields, files, and upload progress |
| `lib/download.dart` | `Http.download`, dynamic save paths, a cancel token, and download progress |
| `lib/custom_adapter.dart` | Injecting an `IOHttpClientAdapter` without disabling TLS validation |

Run another example by replacing the file passed to `dart run`:

```shell
dart run lib/upload.dart
dart run lib/download.dart
dart run lib/formdata.dart
dart run lib/custom_adapter.dart
```

The examples start a temporary loopback HTTP server, so they do not require an
external API. They use the small files in `../assets`; file-based upload and
download examples require a `dart:io` platform.
