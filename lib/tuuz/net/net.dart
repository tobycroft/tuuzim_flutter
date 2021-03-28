import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:path/path.dart';
import 'package:tuuzim_flutter/config/config.dart';

class Net {
  static Future<String> Post(String url, path, Map<String, dynamic> get, Map<String, dynamic> post, Map<String, String> header) async {
    Response response;
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      client.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      client.findProxy = (uri) {
        return "PROXY " + Config.ProxyURL;
      };
    };
    FormData formData = new FormData.fromMap(post);
    response = await dio.post(path, queryParameters: get, data: formData, options: Options(headers: header));
    return response.data.toString();
  }

  static Future<String> PostRaw(String url, path, Map<String, String> get, dynamic post, Map<String, String> header) async {
    var http = new HttpClient();
    if (Config.Proxy_debug) {
      http.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {"http_proxy": Config.ProxyURL});
      };
    }
    var uri;
    if (get == null || get.isEmpty) {
      uri = new Uri.http(url, path);
    } else {
      uri = new Uri.http(url, path, get);
    }
    var req = await http.postUrl(uri);
    if (header != null && !header.isEmpty) {
      header.forEach((key, value) {
        req.headers.add(key, value);
      });
    }
    req.headers.contentType = ContentType.text;
    req.write(post);
    var resp = await req.close();
    var ret = await resp.transform(utf8.decoder).join();
    return ret;
  }

  static Future PostFile(String filepath, Map<String, String> get, post, header) async {
    final uploader = FlutterUploader();
    final taskId = await uploader.enqueue(
      url: Config.Upload,
      //required: url to upload to
      files: [FileItem(filename: basename(filepath), savedDir: dirname(filepath), fieldname: "file")],
      // required: list of files that you want to upload
      method: UploadMethod.POST,
      // HTTP method  (POST or PUT or PATCH)cmd

      headers: header,
      data: post,
      // any data you want to send in upload request
      showNotification: true,
      // send local notification (android only) for upload status
      tag: filepath,
    ); // unique tag for upload task
  }

  static Future<String> PostJson(String url, path, Map<String, String> get, Map<String, dynamic> post, Map<String, String> header) async {
    var http = new HttpClient();
    if (Config.Proxy_debug) {
      http.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {"http_proxy": Config.ProxyURL});
      };
    }
    var uri;
    if (get == null || get.isEmpty) {
      uri = new Uri.http(url, path);
    } else {
      uri = new Uri.http(url, path, get);
    }
    var req = await http.postUrl(uri);
    if (header != null && !header.isEmpty) {
      header.forEach((key, value) {
        req.headers.add(key, value);
      });
    }
    req.headers.contentType = ContentType.text;
    req.writeln(post);
    var resp = await req.close();
    var ret = await resp.transform(utf8.decoder).join();
    return ret;
  }

  static Future<String> Get(String url, path, Map<String, dynamic> get, Map<String, dynamic> header) async {
    Response response;
    BaseOptions options = new BaseOptions(
      baseUrl: url,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    Dio dio = new Dio(options);

    response = await dio.get(path, queryParameters: get, options: Options(headers: header));
    return response.data.toString();

    var http = new HttpClient();
    if (Config.Proxy_debug) {
      http.findProxy = (url) {
        return HttpClient.findProxyFromEnvironment(url, environment: {"http_proxy": Config.ProxyURL});
      };
    }
    var uri;
    if (get == null || get.isEmpty) {
      uri = new Uri.http(url, path);
    } else {
      uri = new Uri.http(url, path, get);
    }
    var req = await http.getUrl(uri);
    if (header != null && !header.isEmpty) {
      header.forEach((key, value) {
        req.headers.add(key, value);
      });
    }
    req.headers.contentType = ContentType.parse("application/x-www-form-urlencoded");
    var resp = await req.close();
    var ret = await resp.transform(utf8.decoder).join();
    return ret;
  }
}
