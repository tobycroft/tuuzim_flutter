import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:tuuzim_flutter/app/index2/info/user_info.dart';
import 'package:tuuzim_flutter/app/index2/search/url_search.dart';
import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/model/GroupModel.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class SearchFriend extends StatefulWidget {
  String _title;
  var _pageparam;

  SearchFriend(this._title, this._pageparam);

  _SearchFriend createState() => _SearchFriend(this._title, this._pageparam);
}

class _SearchFriend extends State<SearchFriend> {
  String _title;
  var _pageparam;

  _SearchFriend(this._title, this._pageparam);

  @override
  void initState() {
    _data=[];
    super.initState();
  }

  String _value;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          keyboardType: TextInputType.text,
          style: Theme.of(context).textTheme.bodyText1,
          decoration: Config.Inputdecoration_default_input_box(Icons.account_box, "输入用户名/手机/地址", false, "请输入数字"),
          onChanged: (String val) {
            this._value = val.toString();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              Map post = await AuthAction().LoginObject();
              post["value"] = this._value;
              String ret = await Net.Post(Config.Url, Url_Search.Search_friend, null, post, null);
              Map json = jsonDecode(ret);
              if (Auth.Return_login_check(context, json)) {
                if (Ret.Check_isok(context, json)) {
                  setState(() {
                    _data = json["data"];
                  });
                }
              }
            },
          )
        ],
      ),
      body: EasyRefresh(
        child: ListView.builder(
          itemBuilder: (context, index) => _group_list_widget(context, _data[index]),
          itemCount: _data.length,
        ),
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
      tileColor: Style.Listtile_color(this._context),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CacheImage.network(ret["face"], 45, 45),
      ),
      contentPadding: EdgeInsets.only(left: 20, top: 2, bottom: 2, right: 20),
      title: Text(
        ret["uname"].toString(),
        style: Config.Text_Style_default,
      ),
      onTap: () {
        Windows.Open(this._context, UserInfo(ret["uname"].toString(), ret));
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}
