import 'package:dio/dio.dart';

import '../../coverters/converter.dart';
import '../../http.dart';
import 'http_abstract_options.dart';
import 'http_retry_options.dart';

/// 请求配置
class HttpOptions<R extends BaseResp<T>, T> extends Options implements HttpAbstractOptions<R, T> {
  // ignore: public_member_api_docs
  HttpOptions({
    Method? method,
    super.sendTimeout,
    super.receiveTimeout,
    super.extra,
    super.headers,
    super.preserveHeaderCase,
    super.responseType,
    ContentType? contentType,
    super.validateStatus,
    super.receiveDataWhenStatusError,
    super.followRedirects,
    super.maxRedirects,
    super.persistentConnection,
    super.requestEncoder,
    super.responseDecoder,
    super.listFormat,
    this.converter,
    this.retryOptions,
  }) : super(
          method: method?.methodName,
          contentType: contentType?.value,
        );

  @override
  final Converter<R, T>? converter;

  @override
  final HttpRetryOptions? retryOptions;
}
