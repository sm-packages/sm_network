import 'package:sm_network/sm_network.dart';
import 'package:sm_network_example/example_server.dart';

Future<void> main(List<String> args) async {
  final server = await ExampleServer.start();
  configHttp(baseUrl: server.baseUri.toString());

  try {
    await rawGet();
    await modelConversion();
  } finally {
    await server.close();
  }
}

void configHttp({
  String? baseUrl,
  Map<String, dynamic>? headers,
  HttpClientAdapter? httpClientAdapter,
  ConverterOptions? converterOptions,
}) {
  Http.shared.config(
    options: HttpBaseOptions(
      baseUrl: baseUrl ?? '',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      validateStatus: (status) => status == 200,
      headers: {
        'user-agent': 'sm_network',
        'accept': 'application/json',
        ...?headers,
      },
      log: HttpLog(
        options: LogOptions.allow(),
        error: (error, stackTrace) {
          print('$error\n$stackTrace');
        },
      ),
      converterOptions: converterOptions ?? const DefaultConverterOptions(),
    ),
    interceptors: [
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('${options.method} ${options.uri}');
          handler.next(options);
        },
      ),
      HttpLogInterceptor(),
    ],
    httpClientAdapter: httpClientAdapter,
  );
}

Future<void> rawGet() async {
  final response = await Http.fetch<Map<String, dynamic>, Object?>(
    path: '/raw',
    method: Method.get,
    queryParameters: {'source': 'sm_network'},
  );

  print('raw status: ${response.statusCode}');
  print('raw data: ${response.data}');
}

Future<void> modelConversion() async {
  final userResponse = await Http.session<User>(
    path: '/model',
    fromJsonT: User.fromJson,
  ).get();

  print('user: ${userResponse.data}');

  final usersResponse = await Http.session<User>(
    path: '/models',
    fromJsonT: User.fromJson,
  ).get();

  print('users: ${usersResponse.list}');
}

final class User {
  const User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
      );

  final int id;
  final String name;

  @override
  String toString() => 'User(id: $id, name: $name)';
}
