import 'package:dio/dio.dart';

import '../../coverters/converter.dart';
import '../../http.dart';
import '../../log.dart';
import 'http_abstract_options.dart';
import 'http_retry_options.dart';

/// 基础配置
class HttpBaseOptions extends BaseOptions implements HttpAbstractOptions {
  // ignore: public_member_api_docs
  HttpBaseOptions({
    Method? method,
    super.connectTimeout,
    super.receiveTimeout,
    super.sendTimeout,
    super.baseUrl = '',
    super.queryParameters,
    super.extra,
    super.headers,
    super.preserveHeaderCase = false,
    super.responseType = ResponseType.json,
    ContentType? contentType,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.persistentConnection,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
    HttpLog? log,
    this.converterOptions = const DefaultConverterOptions(),
    this.retryOptions,
  })  : log = log ?? const HttpLog(),
        super(
          method: method?.methodName,
          contentType: contentType?.value,
        );

  /// 转换选项
  @override
  final ConverterOptions converterOptions;

  /// 是否打印日志
  final HttpLog log;

  @override
  final HttpRetryOptions? retryOptions;
}
