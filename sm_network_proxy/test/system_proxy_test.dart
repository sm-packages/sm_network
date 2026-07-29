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

  Future<String?> proxyDirective(String? proxy) async {
    messenger.setMockMethodCallHandler(channel, (_) async => proxy);
    final client = _RecordingHttpClient();

    await HttpOverrides.runZoned(
      () async {
        final adapter = await SystemProxy.createAdapter() as IOHttpClientAdapter;
        expect(adapter.createHttpClient!(), same(client));
      },
      createHttpClient: (_) => client,
    );

    return client.proxyFor(Uri.https('example.com', '/'));
  }

  for (final (description, proxy, expected) in <(String, String?, String)>[
    (
      'creates an IO adapter with the system proxy',
      '127.0.0.1:8080',
      'PROXY 127.0.0.1:8080',
    ),
    (
      'preserves an explicit port 80 proxy',
      'proxy.example:80',
      'PROXY proxy.example:80',
    ),
    (
      'formats an IPv6 proxy for HttpClient',
      '2001:db8::1:8080',
      'PROXY [2001:db8::1]:8080',
    ),
    (
      'rejects out-of-range proxy ports',
      'proxy.example:70000',
      'DIRECT',
    ),
    ('creates a direct adapter when no system proxy exists', null, 'DIRECT'),
  ]) {
    test(description, () async {
      expect(await proxyDirective(proxy), expected);
    });
  }

  test('creates an HTTP/2 adapter with the system proxy', () async {
    messenger.setMockMethodCallHandler(channel, (_) async => '127.0.0.1:8080');

    expect(await SystemProxy.createAdapter(http2: true), isA<Http2Adapter>());
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
