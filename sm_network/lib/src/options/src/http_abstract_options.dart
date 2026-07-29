import '../../coverters/converter.dart';
import 'http_retry_options.dart';

/// 基础选项
abstract class HttpAbstractOptions {
  // ignore: public_member_api_docs
  HttpAbstractOptions({
    required this.converterOptions,
    this.retryOptions,
  });

  /// 转换选项
  final ConverterOptions converterOptions;

  /// 重试
  final HttpRetryOptions? retryOptions;
}
