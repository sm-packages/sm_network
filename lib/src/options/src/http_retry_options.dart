import 'dart:async';

import '../../../sm_network.dart';

/// 网络请求重试选项
class HttpRetryOptions {
  // ignore: public_member_api_docs
  const HttpRetryOptions({
    this.delayFactor,
    this.randomizationFactor,
    this.maxDelay,
    this.retryCount,
    this.retryIf,
    this.onRetry,
  });

  /// 重试条件
  final RetryFunction<bool>? retryIf;

  /// 重试回调
  final RetryFunction<void>? onRetry;

  /// 延迟因子, 在每次尝试后翻倍。
  ///
  /// 默认为200毫秒，会导致以下延迟：
  ///
  ///  1. 400 ms
  ///  2. 800 ms
  ///  3. 1600 ms
  ///  4. 3200 ms
  ///  5. 6400 ms
  ///  6. 12800 ms
  ///  7. 25600 ms
  ///
  /// 应用于 [randomizationFactor] 之前.
  final Duration? delayFactor;

  /// 放弃前的最大尝试次数，默认为 0 次, 不重试。
  final int? retryCount;

  /// 最大重试间隔，默认为 30 秒。
  final Duration? maxDelay;

  /// 随机百分比系数，以 0 到 1 之间的小数表示。
  /// 如果 [randomizationFactor] 为 `0.25`（默认值），这表示延迟应增加或减少 25%。
  final double? randomizationFactor;

  /// 网络请求重试
  ///
  /// 调用 [fn] 重试，只要 [retryIf] 对于抛出的异常返回 `true`。
  /// 每次重试都会调用 [onRetry] 函数（如果提供）。
  /// 函数 [fn] 最多会被调用 [RetryOptions.maxAttempts] 次。
  /// 如果没有提供 [retryIf] 函数，这将重试任何抛出的 [Exception]。
  /// 要重试 [Error]，错误必须被捕获并作为 [Exception] 重新抛出。
  Future<T> retry<T>(
    FutureOr<T> Function() fn,
  ) =>
      RetryOptions(
        delayFactor: delayFactor ?? const Duration(milliseconds: 200),
        randomizationFactor: randomizationFactor ?? 0.25,
        maxDelay: maxDelay ?? const Duration(seconds: 30),
        maxAttempts: (retryCount ?? 0) + 1,
      ).retry(fn, retryIf: retryIf, onRetry: onRetry);

  /// 拷贝
  HttpRetryOptions copyWith({
    RetryFunction<bool>? retryIf,
    RetryFunction<void>? onRetry,
    Duration? delayFactor,
    int? retryCount,
    Duration? maxDelay,
    double? randomizationFactor,
  }) {
    return HttpRetryOptions(
      retryIf: retryIf ?? this.retryIf,
      onRetry: onRetry ?? this.onRetry,
      delayFactor: delayFactor ?? this.delayFactor,
      retryCount: retryCount ?? this.retryCount,
      maxDelay: maxDelay ?? this.maxDelay,
      randomizationFactor: randomizationFactor ?? this.randomizationFactor,
    );
  }

  /// 合并
  HttpRetryOptions mergeWith(HttpRetryOptions? options) {
    return HttpRetryOptions(
      retryIf: retryIf ?? options?.retryIf,
      onRetry: onRetry ?? options?.onRetry,
      delayFactor: delayFactor ?? options?.delayFactor,
      retryCount: retryCount ?? options?.retryCount,
      maxDelay: maxDelay ?? options?.maxDelay,
      randomizationFactor: randomizationFactor ?? options?.randomizationFactor,
    );
  }
}
