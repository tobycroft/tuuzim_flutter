import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Windows {
  //关闭当前页面或者窗口
  static Close(BuildContext context) {
    return Navigator.pop(context);
  }

  //用于打开动态页面
  static Open(BuildContext context, StatefulWidget any) {
    return Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext contexts) => any));
  }

  //用于打开无动态页面
  static Open_static(BuildContext context, StatelessWidget any) {
    return Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext contexts) => any));
  }

  static Open_url(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {}
  }
}
