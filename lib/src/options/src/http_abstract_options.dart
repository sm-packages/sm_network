import '../../coverters/converter.dart';
import 'http_retry_options.dart';

/// 基础选项
abstract class HttpAbstractOptions<R extends BaseResp<T>, T> {
  // ignore: public_member_api_docs
  HttpAbstractOptions({
    required this.converter,
    this.retryOptions,
  });

  /// 转换
  final Converter<R, T>? converter;

  /// 重试
  final HttpRetryOptions? retryOptions;
}
