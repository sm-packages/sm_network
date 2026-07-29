import 'package:json_annotation/json_annotation.dart';

/// double 转换
class DoubleConverter implements JsonConverter<double?, dynamic> {
  // ignore: public_member_api_docs
  const DoubleConverter({
    this.allowOtherTypes = true,
  });

  /// 是否允许其他类型转换
  /// 如 bool 转 double
  final bool allowOtherTypes;

  @override
  double? fromJson(dynamic json) {
    if (json is double) return json;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json);
    if (allowOtherTypes && json is bool) return json ? 1.0 : 0.0;
    return null;
  }

  @override
  double? toJson(double? object) => object;
}

/// int 转换
class IntConverter implements JsonConverter<int?, dynamic> {
  // ignore: public_member_api_docs
  const IntConverter({
    this.allowOtherTypes = true,
  });

  /// 是否允许其他类型转换
  /// 如 bool 转 int
  final bool allowOtherTypes;

  @override
  int? fromJson(dynamic json) {
    if (json is num) return json.toInt();
    if (json is String) return int.tryParse(json);
    if (allowOtherTypes && json is bool) return json ? 1 : 0;
    return null;
  }

  @override
  int? toJson(int? object) => object;
}

/// num 转换
class NumConverter implements JsonConverter<num?, dynamic> {
  // ignore: public_member_api_docs
  const NumConverter({
    this.allowOtherTypes = true,
  });

  /// 是否允许其他类型转换
  /// 如 bool 转 num
  final bool allowOtherTypes;

  @override
  num? fromJson(dynamic json) {
    if (json is num) return json;
    if (json is String) return num.tryParse(json);
    if (allowOtherTypes && json is bool) return json ? 1 : 0;
    return null;
  }

  @override
  num? toJson(num? object) => object;
}
