import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';

class UserInfo extends StatefulWidget {
  String _title;
  var _pageparam;

  UserInfo(this._title, this._pageparam);

  _UserInfo createState() => _UserInfo(this._title, this._pageparam);
}

class _UserInfo extends State<UserInfo> {
  String _title;
  var _pageparam;

  _UserInfo(this._title, this._pageparam);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white12,
    );
  }
}
