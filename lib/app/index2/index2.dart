import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/group_function_select.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/group_setting_get.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index2 extends StatefulWidget {
  String _title;

  Index2(this._title);

  @override
  _Index2 createState() => _Index2(this._title);
}

class _Index2 extends State<Index2> {
  String _title;

  _Index2(this._title);

  @override
  void initState() {
    _friend_list(context);
    super.initState();
  }

  Future<void> _friend_list(BuildContext context) async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.Friend_list, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          if (json["data"] != null) {
            _data = json["data"];
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(this._title),
        backgroundColor: Colors.black,
        // If `TabController controller` is not provided, then a
        // DefaultTabController ancestor must be provided instead.
        // Another way is to use a self-defined controller, c.f. "Bottom tab
        // bar" example.
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (BuildContext con, int index) => _group_list_widget(context, _data[index]),
          itemCount: _data.length,
        ),
        onRefresh: () async {
          _friend_list(context);
        },
        firstRefresh: false,
      ),
    );
  }
}

List _data = [];

class _group_list_widget extends StatelessWidget {
  var _pageparam;
  BuildContext _context;

  _group_list_widget(this._context, this._pageparam);

  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          (ret["face"]),
          width: 45,
          height: 45,
          fit: BoxFit.cover,
        ),
      ),
      contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
      title: Text(
        ret["uname"].toString(),
        style: Config.Text_Style_default.copyWith(color: Colors.white),
      ),
      onTap: () {},
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}
