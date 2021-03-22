import 'dart:convert';

import 'package:flutter/cupertino.dart';
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
    var extra = null;
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
        break;

      case "2":
        return Container(
          width: 200,
          height: 200,
          child: CacheImage.fullscreen(extra["img"], double.infinity, double.infinity),
        );
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
