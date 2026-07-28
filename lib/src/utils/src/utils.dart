import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:meta/meta.dart';

import '../../http.dart';

@internal
final class Utils {
  factory Utils() => _instance;
  Utils._();
  static final _instance = Utils._();

  /// 单例
  static Utils get shared => _instance;

  /// json
  String jsonConverter(
    dynamic data, {
    required String Function([int]) indent,
    bool isCurl = false,
  }) {
    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (e) {
        return '${isCurl ? '' : indent()}$data';
      }
    }
    var json = JsonEncoder.withIndent(indent(isCurl ? 2 : 1)).convert(data);

    if (isCurl) {
      json = json.replaceRange(json.length - 1, null, '${indent()}}');
    } else {
      json = json.splitMapJoin(
        '\n',
        onNonMatch: (line) => indent() + line,
      );
    }

    return json;
  }

  /// 处理 request data 日志
  (dynamic, String?) processLogRequestData(
    dynamic data,
    ContentType? contentType,
    String Function([int]) indent, {
    bool isCurl = false,
  }) {
    if (data != null) {
      String? dataType;
      switch (contentType) {
        case ContentType.raw:
          dataType = 'Text Plain';
        case ContentType.json:
          dataType = 'Json';
        case ContentType.urlencoded:
          dataType = 'Form Urlencoded';
        case ContentType.multipart:
          dataType = 'Form Data';
        default:
          break;
      }
      if (data is FormData) {
        if (isCurl) {
          return (
            [
              ...data.fields.map(
                (e) => '${indent()}--form \'${e.key}="${e.value}"\'',
              ),
              ...data.files.map(
                (e) => '${indent()}--form \'${e.key}=@"${e.value.filename}"\'',
              ),
            ],
            null,
          );
        } else {
          final formDataMap = <String, dynamic>{}
            ..addAll(mergeListToMap(data.fields))
            ..addEntries(
              data.files.map(
                (e) => MapEntry(
                  e.key,
                  {
                    'filename': e.value.filename,
                    'length': e.value.length,
                    'contentType': e.value.contentType?.mimeType,
                    'isFinalized': e.value.isFinalized,
                  },
                ),
              ),
            );
          return (formDataMap, 'Request ${dataType ?? 'Form Data'}');
        }
      } else if (contentType == ContentType.urlencoded) {
        if (isCurl) {
          return (
            // ignore: avoid_dynamic_calls
            data.entries.map(
              (MapEntry e) {
                return "${indent()}--data-urlencode '${e.key}=${e.value}'";
              },
            ),
            null,
          );
        } else {
          return (data, 'Request ${dataType ?? 'Form Urlencoded'}');
        }
      } else {
        if (isCurl) {
          return (
            jsonConverter(
              data,
              indent: indent,
              isCurl: isCurl,
            ),
            null,
          );
        } else {
          return (data, 'Request ${dataType ?? 'Data'}');
        }
      }
    }
    return (null, null);
  }

  /// 处理 request data
  Object? processRequestData({
    Object? data,
    FormFiles? files,
    ContentType? contentType,
  }) {
    // 处理 upload
    if (files != null) {
      data ??= Parameters.from({});
      if (data is Parameters) {
        data = FormData.fromMap({...data, ...files});
      } else {
        throw ArgumentError('data must be Parameters when files is not null');
      }
    }
    // 处理请求体
    if (data != null) {
      if (contentType == ContentType.json) {
        data = jsonEncode(data);
      } else if (contentType == ContentType.multipart && data is Parameters) {
        data = FormData.fromMap(data);
      }
    }
    return data;
  }

  Map<String, dynamic> mergeListToMap(List<MapEntry<String, dynamic>> inputList) {
    return inputList.fold(
      {},
      (result, entry) {
        final key = entry.key;
        final value = entry.value;

        if (result.containsKey(key)) {
          if (result[key] is List) {
            (result[key] as List).add(value);
          } else {
            result[key] = [result[key], value];
          }
        } else {
          result[key] = value;
        }

        return result;
      },
    );
  }
}
