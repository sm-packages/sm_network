package io.github.shay_wong.sm_network_proxy;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

// Portions adapted from proxy_kit 2.0.0 and modified for sm_network_proxy.
// See THIRD_PARTY_NOTICES in the package root.
/** Provides the current Android system HTTP proxy. */
public final class SmNetworkProxyPlugin implements FlutterPlugin, MethodChannel.MethodCallHandler {
    private MethodChannel channel;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "sm_network/proxy");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (!"getProxy".equals(call.method)) {
            result.notImplemented();
            return;
        }

        result.success(readSystemProxy());
    }

    static String readSystemProxy() {
        final String host = System.getProperty("http.proxyHost");
        final String port = System.getProperty("http.proxyPort");
        if (host == null || host.isEmpty() || port == null || port.isEmpty()) {
            return null;
        }

        try {
            final int parsedPort = Integer.parseInt(port);
            return parsedPort >= 1 && parsedPort <= 65535 ? host + ":" + parsedPort : null;
        } catch (NumberFormatException ignored) {
            return null;
        }
    }
}
