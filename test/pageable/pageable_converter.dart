import 'dart:convert';

import 'package:sm_network/sm_network.dart';

import 'pageable_resp.dart';

/// 默认数据转换
class PageableConverter<R extends BaseResp<T>, T> extends Converter<R, T> {
  // ignore: public_member_api_docs
  const PageableConverter({super.fromJsonT, super.options = const DefaultConverterOptions()});

  @override
  R error(
    dynamic error, {
    String? message,
    int? code,
  }) =>
      PageableResp<T>(
        error: error,
        message: message ?? const StringConverter().fromJson(error),
        code: code,
      ) as R;

  @override
  R exception(DioException exception) {
    final response = exception.response;
    return error(
      exception.error is HttpError ? exception.error : exception,
      message: exception.message ?? response?.statusMessage,
      code: response?.statusCode,
    );
  }

  @override
  R success(Response response) {

    dynamic data = response.data;
    if (data is! Parameters) {
      data = _decodeData(data);
    }
    if (data is Parameters) {
      return _handleResponse(data);
    }
    return PageableResp<T>(
      code: response.statusCode,
      data: data,
      message: response.statusMessage,
      status: response.requestOptions.validateStatus(response.statusCode),
    ) as R;
  }

  /// 解码数据
  dynamic _decodeData(dynamic data) {
    try {
      return jsonDecode(data);
    } catch (e) {
      return data;
    }
  }

  /// 生成对象
  T? _generateObj(dynamic data) {
    try {
      dynamic obj;
      if (fromJsonT != null && data != null) {
        obj = fromJsonT!(data);
      } else {
        obj = data;
      }
      return obj as T?;
    } catch (e) {
      rethrow;
    }
  }

  R _handleResponse(Parameters responseData) {
    final code = const IntConverter().fromJson(responseData.getNestedValue(options.code));
    final data = responseData.getNestedValue(options.data) as Parameters?;
    final message = const StringConverter().fromJson(responseData.getNestedValue(options.message));
    final list = (data?['list'] as List?)?.map(_generateObj).whereType<T>().toList();
    final pageNumber = const IntConverter().fromJson(data?['pageNumber']);
    final pages = const IntConverter().fromJson(data?['pages']);
    final pageSize = const IntConverter().fromJson(data?['pageSize']);
    final total = const IntConverter().fromJson(data?['total']);

    return PageableResp<T>(
      code: code,
      list: list,
      message: message,
      pageNumber: pageNumber,
      pageSize: pageSize,
      pages: pages,
      total: total,
      status: options.status?.call(code, responseData),
    ) as R;
  }
}
