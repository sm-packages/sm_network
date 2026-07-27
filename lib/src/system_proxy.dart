import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// Portions adapted from proxy_kit 2.0.0 and modified for sm_network.
// See THIRD_PARTY_NOTICES in the package root.
@internal
final class SystemProxy {
  const SystemProxy._();

  static const _channel = MethodChannel('sm_network/proxy');

  static Future<String?> getProxy() async {
    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      return null;
    }
    return _channel.invokeMethod<String>('getProxy');
  }
}
