import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';

class WidgetPrivateMessage extends StatelessWidget {
  var _context;
  var _type;
  var _message;
  var _extra;
  var _date;
  var _ident;
  var _data;

  WidgetPrivateMessage(this._context, this._data, this._type, this._message, this._extra, this._date, this._ident);

  @override
  Widget build(BuildContext context) {
    Map extra = {};
    try {
      extra = jsonDecode(this._extra);
    } catch (e) {}
    switch (this._type.toString()) {
      case "1":
        return new Text(
          this._message.toString(),
          maxLines: 999,
          overflow: TextOverflow.ellipsis,
        );

      case "2":
        if (extra["img"] != null) {
          return Container(
            width: 200,
            height: 200,
            child: CacheImage.fullscreen(extra["img"], double.infinity, double.infinity),
          );
        } else {
          return Container(
            width: 200,
            height: 200,
          );
        }
        break;

      case "3":

        if (extra["path"] != null) {
          return Container(
            width: 300,
            height: 100,
            child: WidgetAudio(),
          );
        } else {
          return Container(
            width: 300,
            height: 100,
          );
        }
        break;

      case "5": //视频
        if (extra["thumbPath"] != null) {
          return Container(
            width: 320,
            height: 380,
            child: CacheImage.Video(this._context, extra["thumbPath"], extra["videoPath"]),
          );
        } else {
          return Container(
            width: 320,
            height: 360,
          );
        }
        break;

      case "4": //文件
        if (extra["size"] != null) {
          return Container(
            width: 200,
            height: 100,
          );
        } else {
          return Container(
            width: 200,
            height: 100,
          );
        }
        break;

      case "7": //名片
        if (extra["id"] != null) {
          return Container(
            width: 200,
            height: 100,
          );
        } else {
          return Container(
            width: 200,
            height: 100,
          );
        }
        break;

      default:
        return new Text(
          this._message.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
        break;
    }
  }
}
