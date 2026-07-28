import CFNetwork
import Flutter
import Foundation

// Portions adapted from proxy_kit 2.0.0 and modified for sm_network.
// See THIRD_PARTY_NOTICES in the package root.
public final class SmNetworkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "sm_network/proxy",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(SmNetworkPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "getProxy" else {
      result(FlutterMethodNotImplemented)
      return
    }

    guard
      let settings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
      let enabled = settings[kCFNetworkProxiesHTTPEnable as String] as? NSNumber,
      enabled.boolValue,
      let host = settings[kCFNetworkProxiesHTTPProxy as String] as? String,
      let port = settings[kCFNetworkProxiesHTTPPort as String] as? NSNumber
    else {
      result(nil)
      return
    }

    result("\(host):\(port.intValue)")
  }
}
