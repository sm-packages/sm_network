package io.github.shay_wong.sm_network;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

// Locks the proxy_kit-compatible system-property contract without an Android runtime.
public final class SmNetworkPluginTest {
    private String originalHost;
    private String originalPort;

    @Before
    public void saveProxyProperties() {
        originalHost = System.getProperty("http.proxyHost");
        originalPort = System.getProperty("http.proxyPort");
    }

    @After
    public void restoreProxyProperties() {
        restoreProperty("http.proxyHost", originalHost);
        restoreProperty("http.proxyPort", originalPort);
    }

    @Test
    public void readSystemProxyNormalizesThePort() {
        System.setProperty("http.proxyHost", "127.0.0.1");
        System.setProperty("http.proxyPort", "08080");

        assertEquals("127.0.0.1:8080", SmNetworkPlugin.readSystemProxy());
    }

    @Test
    public void readSystemProxyRejectsInvalidPorts() {
        System.setProperty("http.proxyHost", "127.0.0.1");
        System.setProperty("http.proxyPort", "invalid");
        assertNull(SmNetworkPlugin.readSystemProxy());

        System.setProperty("http.proxyPort", "-1");
        assertNull(SmNetworkPlugin.readSystemProxy());
    }

    @Test
    public void readSystemProxyRequiresAHostAndPort() {
        System.clearProperty("http.proxyHost");
        System.clearProperty("http.proxyPort");

        assertNull(SmNetworkPlugin.readSystemProxy());
    }

    private static void restoreProperty(String name, String value) {
        if (value == null) {
            System.clearProperty(name);
        } else {
            System.setProperty(name, value);
        }
    }
}
