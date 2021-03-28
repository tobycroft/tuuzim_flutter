import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:tuuzim_flutter/config/config.dart';

class Net {
  static Response_handler(Response response) {
    switch (response.request.responseType) {
      case ResponseType.plain:
        return response.data;

      case ResponseType.json:
        if (response.data.runtimeType == String) {
          return response.data;
        } else {
          return jsonEncode(response.data);
        }
        break;

      case ResponseType.bytes:
        return response.data;

      case ResponseType.stream:
        return response.data;

      default:
        print(response.request.responseType);
        return response.data;
    }
  }

  static BaseOptions options = new BaseOptions(
    baseUrl: Config.Url,
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );

  static Future<dynamic> Post(String url, path, Map<String, dynamic> get, dynamic post, Map<String, String> header) async {
    Response response;
    if (url != null) {
      options.baseUrl = url;
    }
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      if (Config.Proxy_debug) {
        client.findProxy = (uri) {
          return "PROXY " + Config.ProxyURL;
        };
      }
    };
    response = await dio.post(path, queryParameters: get, data: post, options: Options(headers: header, contentType: Headers.formUrlEncodedContentType));
    return Response_handler(response);
  }

  static Future<dynamic> PostRaw(String url, path, Map<String, String> get, dynamic post, Map<String, String> header) async {
    Response response;
    if (url != null) {
      options.baseUrl = url;
    }
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      if (Config.Proxy_debug) {
        client.findProxy = (uri) {
          return "PROXY " + Config.ProxyURL;
        };
      }
    };
    response = await dio.post(path, queryParameters: get, data: post, options: Options(headers: header));
    return Response_handler(response);
  }

  static Future<dynamic> PostFile(String filePath, Map<String, dynamic> post, header) async {
    Response response;
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      if (Config.Proxy_debug) {
        client.findProxy = (uri) {
          return "PROXY " + Config.ProxyURL;
        };
      }
    };
    if (post == null) {
      post = {};
    }
    post["file"] = await MultipartFile.fromFile(filePath, filename: basename(filePath));
    var fd = FormData.fromMap(post);
    response = await dio.post(Config.Upload, data: fd, options: Options(headers: header));
    return Response_handler(response);
  }

  static Future<dynamic> PostJson(String url, path, Map<String, String> get, Map<String, dynamic> post, Map<String, String> header) async {
    Response response;
    if (url != null) {
      options.baseUrl = url;
    }
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      if (Config.Proxy_debug) {
        client.findProxy = (uri) {
          return "PROXY " + Config.ProxyURL;
        };
      }
    };
    response = await dio.post(path, queryParameters: get, data: post, options: Options(headers: header, contentType: Headers.jsonContentType));
    return Response_handler(response);
  }

  static Future<dynamic> Get(String url, path, Map<String, dynamic> get, Map<String, dynamic> header) async {
    Response response;
    if (url != null) {
      options.baseUrl = url;
    }
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      if (Config.Proxy_debug) {
        client.findProxy = (uri) {
          return "PROXY " + Config.ProxyURL;
        };
      }
    };
    response = await dio.get(path, queryParameters: get, options: Options(headers: header));
    return Response_handler(response);
  }
}
