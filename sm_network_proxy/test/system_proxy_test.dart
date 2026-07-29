import 'dart:io';

import 'package:dio/io.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sm_network_proxy/sm_network_proxy.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('sm_network/proxy');
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  });

  tearDown(() {
    messenger.setMockMethodCallHandler(channel, null);
    debugDefaultTargetPlatformOverride = null;
  });

  test('creates an IO adapter with the system proxy', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => '127.0.0.1:8080');
    final client = _RecordingHttpClient();

    await HttpOverrides.runZoned(
      () async {
        final adapter = await SystemProxy.createAdapter() as IOHttpClientAdapter;
        expect(adapter.createHttpClient!(), same(client));
      },
      createHttpClient: (_) => client,
    );

    expect(
      client.proxyFor(Uri.https('example.com', '/')),
      'PROXY 127.0.0.1:8080',
    );
  });

  test('creates an HTTP/2 adapter with the system proxy', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => '127.0.0.1:8080');

    expect(await SystemProxy.createAdapter(http2: true), isA<Http2Adapter>());
  });

  test('creates a direct adapter when no system proxy exists', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => null);
    final client = _RecordingHttpClient();

    await HttpOverrides.runZoned(
      () async {
        final adapter = await SystemProxy.createAdapter() as IOHttpClientAdapter;
        adapter.createHttpClient!();
      },
      createHttpClient: (_) => client,
    );

    expect(client.proxyFor(Uri.https('example.com', '/')), 'DIRECT');
  });
}

final class _RecordingHttpClient implements HttpClient {
  String Function(Uri)? _findProxy;

  String? proxyFor(Uri uri) => _findProxy?.call(uri);

  @override
  set findProxy(String Function(Uri)? value) => _findProxy = value;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
