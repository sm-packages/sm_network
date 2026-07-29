import 'dart:async';

import 'package:dio/dio.dart';

import 'coverters/converter.dart';
import 'error.dart';
import 'http.dart';
import 'options/options.dart';
import 'utils/src/utils.dart';

/// 请求接口
abstract class RequestMethod<R extends BaseResp<T>, T> {
  /// Convenience method to make an HTTP DELETE request.
  Future<R> delete({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP DELETE request with [Uri].
  Future<R> deleteUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  });

  /// {@template dio.Dio.download}
  /// Download the file and save it in local. The default http method is "GET",
  /// you can custom it by [Options.method].
  ///
  /// [path] is the file url.
  ///
  /// The file will be saved to the path specified by [savePath].
  /// The following two types are accepted:
  /// 1. `String`: A path, eg "xs.jpg"
  /// 2. `FutureOr<String> Function(Headers headers)`, for example:
  ///    ```dart
  ///    await dio.download(
  ///      url,
  ///      (Headers headers) {
  ///        // Extra info: redirect counts
  ///        print(headers.value('redirects'));
  ///        // Extra info: real uri
  ///        print(headers.value('uri'));
  ///        // ...
  ///        return (await getTemporaryDirectory()).path + 'file_name';
  ///      },
  ///    );
  ///    ```
  ///
  /// [onReceiveProgress] is the callback to listen downloading progress.
  /// Please refer to [ProgressCallback].
  ///
  /// [deleteOnError] whether delete the file when error occurs.
  /// The default value is `true`.
  ///
  /// [fileAccessMode]
  /// {@macro dio.options.FileAccessMode}
  ///
  /// [lengthHeader] : The real size of original file (not compressed).
  /// When file is compressed:
  /// 1. If this value is 'content-length', the `total` argument of
  ///    [onReceiveProgress] will be -1.
  /// 2. If this value is not 'content-length', maybe a custom header indicates
  ///    the original file size, the `total` argument of [onReceiveProgress]
  ///    will be this header value.
  ///
  /// You can also disable the compression by specifying the 'accept-encoding'
  /// header value as '*' to assure the value of `total` argument of
  /// [onReceiveProgress] is not -1. For example:
  ///
  /// ```dart
  /// await dio.download(
  ///   url,
  ///   (await getTemporaryDirectory()).path + 'flutter.svg',
  ///   options: Options(
  ///     headers: {HttpHeaders.acceptEncodingHeader: '*'}, // Disable gzip
  ///   ),
  ///   onReceiveProgress: (received, total) {
  ///     if (total <= 0) return;
  ///     print('percentage: ${(received / total * 100).toStringAsFixed(0)}%');
  ///   },
  /// );
  /// ```
  /// {@endtemplate}
  Future<R> download({
    String? path,
    dynamic savePath,
    Object? data,
    Map<String, dynamic>? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  });

  /// {@macro dio.Dio.download}
  Future<R> downloadUri({
    Uri? uri,
    dynamic savePath,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  });

  /// The eventual method to submit requests. All callers for requests should
  /// eventually go through this method.
  Future<Response<E>> fetch<E>({
    String? path,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    Parameters? queryParameters,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP GET request.
  Future<R> get({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP GET request with [Uri].
  Future<R> getUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP HEAD request.
  Future<R> head({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP HEAD request with [Uri].
  Future<R> headUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP PATCH request.
  Future<R> patch({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP PATCH request with [Uri].
  Future<R> patchUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP POST request.
  Future<R> post({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP POST request with [Uri].
  Future<R> postUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP PUT request.
  Future<R> put({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP PUT request with [Uri].
  Future<R> putUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Make HTTP request with options.
  Future<R> request({
    String? path,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    Parameters? queryParameters,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Converter<R, T>? converter,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  });

  /// Make http request with options with [Uri].
  Future<R> requestUri({
    Uri? uri,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Converter<R, T>? converter,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP upload file request
  Future<R> upload({
    String? path,
    Parameters? fields,
    FormFiles? files,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });

  /// Convenience method to make an HTTP upload file request with [Uri].
  Future<R> uploadUri({
    Uri? uri,
    Parameters? fields,
    FormFiles? files,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  });
}

/// 请求混入
mixin RequestMixin<R extends BaseResp<T>, T> on HttpOptionsMixin<R, T>
    implements RequestMethod<R, T> {
  Utils get _utils => Utils.shared;

  @override
  Future<R> delete({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.delete,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> deleteUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.delete,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> download({
    String? path,
    dynamic savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    Object? data,
    HttpOptions<R, T>? options,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.download,
      path: path,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      fileAccessMode: fileAccessMode,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> downloadUri({
    Uri? uri,
    dynamic savePath,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    Object? data,
    HttpOptions<R, T>? options,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.download,
      uri: uri,
      savePath: savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      fileAccessMode: fileAccessMode,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
      retryOptions: retryOptions,
    );
  }

  /// [method] 方法名，[options] 中的 [method] 优先级最高
  @override
  Future<Response<E>> fetch<E>({
    String? path,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    Parameters? queryParameters,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  }) async {
    retryOptions = retryOptions?.mergeWith(this.retryOptions) ?? this.retryOptions;

    try {
      data = _utils.processRequestData(
        data: data,
        files: files,
        contentType: contentType,
      );

      if (retryOptions != null) {
        return await retryOptions.retry(
          () => _fetch<E>(
            path: path,
            savePath: savePath,
            data: data,
            files: files,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
            options: options,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress,
            deleteOnError: deleteOnError,
            fileAccessMode: fileAccessMode,
            lengthHeader: lengthHeader,
          ),
        );
      } else {
        return await _fetch<E>(
          path: path,
          savePath: savePath,
          data: data,
          files: files,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: options,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          deleteOnError: deleteOnError,
          fileAccessMode: fileAccessMode,
          lengthHeader: lengthHeader,
        );
      }
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<E>> _fetch<E>({
    String? path,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    Parameters? queryParameters,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
  }) async {
    path ??= this.path;
    savePath ??= this.savePath;
    method ??= this.method;
    options?.method ??= method?.methodName;
    data ??= this.data;
    files ??= this.files;
    queryParameters ??= parameters;
    options ??= this.options;
    cancelToken ??= this.cancelToken;
    onReceiveProgress ??= this.onReceiveProgress;

    Response response;

    if (method == Method.download) {
      // 处理 download 默认值
      deleteOnError ??= this.deleteOnError ?? true;
      fileAccessMode ??= this.fileAccessMode ?? FileAccessMode.write;
      lengthHeader ??= this.lengthHeader ?? Headers.contentLengthHeader;

      response = await dio.download(
        path ?? '',
        savePath ?? '',
        onReceiveProgress: onReceiveProgress,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        fileAccessMode: fileAccessMode,
        lengthHeader: lengthHeader,
        data: data,
        options: options,
      );
    } else {
      onSendProgress ??= this.onSendProgress;

      response = await dio.request<E>(
        path ?? '',
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    }

    return _validateResponse(response);
  }

  @override
  Future<R> get({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.get,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> getUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.get,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> head({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.head,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> headUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.head,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> patch({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.patch,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> patchUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.patch,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> post({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.post,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> postUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.post,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> put({
    String? path,
    Object? data,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.put,
      path: path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> putUri({
    Uri? uri,
    Object? data,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      method: Method.put,
      uri: uri,
      data: data,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> request({
    String? path,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    Parameters? queryParameters,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Converter<R, T>? converter,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  }) async {
    converter ??= this.converter;

    try {
      final response = await fetch(
        path: path,
        savePath: savePath,
        method: method,
        data: data,
        files: files,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        deleteOnError: deleteOnError,
        fileAccessMode: fileAccessMode,
        lengthHeader: lengthHeader,
        retryOptions: retryOptions,
      );
      return converter.success(response);
    } on DioException catch (e) {
      return converter.exception(e);
    } catch (e, stackTrace) {
      if (Http.shared.options.log.captch.error) {
        Http.shared.options.log.error(
          'path: ${path ?? this.path} \nError: $e',
          stackTrace,
        );
      }
      return converter.error(e);
    }
  }

  @override
  Future<R> requestUri({
    Uri? uri,
    dynamic savePath,
    Method? method,
    Object? data,
    FormFiles? files,
    CancelToken? cancelToken,
    HttpOptions<R, T>? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    Converter<R, T>? converter,
    bool? deleteOnError,
    FileAccessMode? fileAccessMode,
    String? lengthHeader,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      path: uri?.toString(),
      savePath: savePath,
      method: method,
      data: data,
      files: files,
      cancelToken: cancelToken,
      options: options,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      converter: converter,
      deleteOnError: deleteOnError,
      fileAccessMode: fileAccessMode,
      lengthHeader: lengthHeader,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> upload({
    String? path,
    Parameters? fields,
    FormFiles? files,
    Parameters? queryParameters,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return request(
      method: Method.upload,
      path: path,
      data: fields,
      files: files,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  @override
  Future<R> uploadUri({
    Uri? uri,
    Parameters? fields,
    FormFiles? files,
    HttpOptions<R, T>? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    HttpRetryOptions? retryOptions,
  }) {
    return requestUri(
      uri: uri,
      data: fields,
      files: files,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
      retryOptions: retryOptions,
    );
  }

  Response<E> _validateResponse<E>(Response response) {
    if (response.requestOptions.validateStatus(response.statusCode)) {
      return response as Response<E>;
    } else {
      final message = 'statusCode: ${response.statusCode}, service error(validate failed)';
      final exception = DioException(
        response: response,
        error: HttpError(message),
        type: DioExceptionType.badResponse,
        requestOptions: response.requestOptions,
        message: message,
      );

      if (Http.shared.options.log.captch.exception) {
        Http.shared.options.log.error(
          'path: $path \n$exception',
          exception.stackTrace,
        );
      }
      throw exception;
    }
  }
}
