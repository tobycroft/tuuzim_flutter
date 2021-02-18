import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/model/GroupModel.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';

class GroupList extends StatefulWidget {
  String _title;
  var _pageparam;

  GroupList(this._title, this._pageparam);

  _GroupList createState() => _GroupList(this._title, this._pageparam);
}

class _GroupList extends State<GroupList> {
  String _title;
  var _pageparam;

  _GroupList(this._title, this._pageparam);

  @override
  void initState() {
    _group_list(context);
    // _friend_list(context);
    super.initState();
  }

  Future<void> _group_list(BuildContext context) async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.GroupList, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        _data = [];
        setState(() {
          _data += json["data"]["admin"];
          _data += json["data"]["member"];
          _data += json["data"]["other"];
          _data += json["data"]["owner"];
        });
        _data.forEach((element) async {
          if (await GroupModel.Api_find(element["id"]) != null) {
            await GroupModel.Api_delete(element["id"]);
          }
          await GroupModel.Api_insert(element["id"], element["announcement"], element["ban_all"], element["can_add"], element["can_recommend"], element["category"], element["direct_join_group"],
              element["group_name"], element["img"], element["introduction"], element["max_admin_count"], element["max_member_count"]);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
        actions: [
          FlatButton(
            onPressed: () async {},
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (context, index) => _group_list_widget(context, _data[index]),
          itemCount: _data.length,
        ),
        onRefresh: () async {
          _group_list(context);
        },
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
        child: CacheImage.network(ret["img"], 45, 45),
      ),
      contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
      title: Text(
        ret["group_name"].toString(),
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
