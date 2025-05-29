import 'package:dio/dio.dart';

import '../../coverters/converter.dart';
import '../../http.dart';
import '../../utils/utils.dart';
import 'http_options.dart';
import 'http_retry_options.dart';

/// 参数混入
mixin HttpOptionsMixin<R extends BaseResp<T>, T> {
  /// 取消 Token
  CancelToken? get cancelToken => null;

  /// Content-Type
  ContentType? get contentType => null;

  /// 数据转换
  Converter<R, T> get converter => DefaultConverter<R, T>(
        fromJsonT: fromJsonT,
        options: Http.shared.options.converterOptions,
      );

  /// 重试选项
  HttpRetryOptions? get retryOptions => retryCount == null
      ? null
      : HttpRetryOptions(
          retryCount: retryCount,
          retryIf: retryIf,
          onRetry: onRetry,
        );

  /// 重试次数。
  int? get retryCount => null;

  /// 重试条件
  RetryFunction<bool>? get retryIf => null;

  /// 重试回调
  RetryFunction<void>? get onRetry => null;

  /// 请求体数据 默认 null
  Object? get data => null;

  /// 发生错误时是否删除文件
  /// 默认为 true
  /// 非 [Method.download] 时无效
  bool? get deleteOnError => null;

  /// dio
  Dio get dio => Http.dio;

  /// 额外参数
  Parameters? get extra => null;

  /// 下载文件时的文件访问模式
  /// 非 [Method.download] 时无效
  FileAccessMode? get fileAccessMode => null;

  /// 上传文件
  /// [files] 的 `value` 必须是 [MultipartFile]
  /// 当使用 [files] 文件上传时, [data] 必须是 [Parameters]
  FormFiles? get files => null;

  /// 跟随重定向
  bool? get followRedirects => null;

  /// json 转换
  FromJsonT<T>? get fromJsonT => null;

  /// 请求头 默认 null
  HTTPHeaders? get headers => null;

  /// 原始文件的实际大小（未压缩）。
  /// 非 [Method.download] 时无效
  String? get lengthHeader => null;

  /// 数组格式
  ListFormat? get listFormat => null;

  /// 最大重定向次数
  int? get maxRedirects => null;

  /// 请求方式 默认 GET
  Method? get method => null;

  /// 接收进度
  ProgressCallback? get onReceiveProgress => null;

  /// 上传进度
  ProgressCallback? get onSendProgress => null;

  /// 请求配置
  HttpOptions<R, T>? get options => HttpOptions<R, T>(
        method: method,
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        extra: extra,
        headers: headers,
        preserveHeaderCase: preserveHeaderCase,
        responseType: responseType,
        contentType: contentType,
        validateStatus: validateStatus,
        receiveDataWhenStatusError: receiveDataWhenStatusError,
        followRedirects: followRedirects,
        maxRedirects: maxRedirects,
        persistentConnection: persistentConnection,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        listFormat: listFormat,
        converter: converter,
        retryOptions: retryOptions,
      );

  /// 请求参数 默认 null
  Parameters? get parameters => null;

  /// 请求路径 默认 null
  String? get path => null;

  /// 持久化连接
  bool? get persistentConnection => null;

  /// 保留 Header 大小写
  bool? get preserveHeaderCase => null;

  /// 状态错误时是否接收数据
  bool? get receiveDataWhenStatusError => null;

  /// 接收超时时间
  Duration? get receiveTimeout => null;

  /// 请求编码
  RequestEncoder? get requestEncoder => null;

  /// 响应解码
  ResponseDecoder? get responseDecoder => null;

  /// 响应类型
  ResponseType? get responseType => null;

  /// 文件保存路径
  /// 非 [Method.download] 时无效
  dynamic get savePath => null;

  /// 发送超时时间
  Duration? get sendTimeout => null;

  /// 请求状态校验
  ValidateStatus? get validateStatus => null;
}
