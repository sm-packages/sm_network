/// HTTP客户端配置选项
class HttpClientOptions {
  /// 构造函数
  HttpClientOptions({
    this.enable = false,
    this.h2 = false,
    this.pem,
    this.pKCSPath,
    this.pKCSPwd,
  });

  /// 是否启用
  bool enable;

  /// 是否开启http2.0
  bool h2;

  /// PEM证书内容.
  String? pem;

  /// 受 `SecurityContext.setTrustedCertificates` 支持的证书路径。
  ///
  /// iOS 仅支持单个 DER X.509 证书；其他 I/O 平台支持 PEM 或 PKCS12。
  String? pKCSPath;

  /// PKCS12 证书密码；PEM 和 DER 证书会忽略此值。
  String? pKCSPwd;
}
