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

  /// PKCS12 证书路径.
  String? pKCSPath;

  /// PKCS12 证书密码.
  String? pKCSPwd;
}
