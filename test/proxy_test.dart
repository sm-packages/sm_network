import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sm_network/sm_network.dart';
import 'package:sm_network/src/system_proxy.dart';

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
    Http.shared.environment.clear();
  });

  test('config reads the system proxy from the native plugin', () async {
    MethodCall? receivedCall;
    messenger.setMockMethodCallHandler(channel, (call) async {
      receivedCall = call;
      return '127.0.0.1:8080';
    });

    await Http.shared.config(
      httpClientOptions: HttpClientOptions(enable: true),
    );

    expect(receivedCall?.method, 'getProxy');
    expect(Http.shared.environment, {
      'http_proxy': '127.0.0.1:8080',
      'https_proxy': '127.0.0.1:8080',
    });
  });

  // Desktop callers must not depend on a mobile plugin registration.
  test('system proxy ignores the native channel on unsupported platforms', () async {
    var called = false;
    messenger.setMockMethodCallHandler(channel, (_) async {
      called = true;
      return '127.0.0.1:8080';
    });
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;

    final proxy = await SystemProxy.getProxy();

    expect(called, isFalse);
    expect(proxy, isNull);
  });

  // Mobile packaging errors must remain visible instead of silently disabling proxying.
  test('system proxy surfaces missing native registration on mobile', () async {
    await expectLater(
      SystemProxy.getProxy(),
      throwsA(isA<MissingPluginException>()),
    );
  });
}
