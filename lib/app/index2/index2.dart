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
    group_control(context);
    group_joined(context);
    super.initState();
  }

  Future<void> group_control(BuildContext context) async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.Group_list_control, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          if (json["data"] != null) {
            _group_control = json["data"];
          }
        });
      }
    }
  }

  Future<void> group_joined(BuildContext context) async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.Group_list_joined, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        setState(() {
          if (json["data"] != null) {
            _group_joined = json["data"];
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _kTabPages = <Widget>[
      EasyRefresh(
        child: ListView.builder(
          itemBuilder: (BuildContext con, int index) => _group_list_widget(context, _group_control[index], _widget_type.set),
          itemCount: _group_control.length,
        ),
        onRefresh: () async {
          group_control(this.context);
        },
        firstRefresh: false,
      ),
      EasyRefresh(
        child: ListView.builder(
          itemBuilder: (BuildContext con, int index) => _group_list_widget(context, _group_joined[index], _widget_type.get),
          itemCount: _group_joined.length,
        ),
        onRefresh: () async {
          group_joined(this.context);
        },
        firstRefresh: false,
      ),
    ];
    final _kTabs = <Tab>[
      const Tab(icon: Icon(Icons.check_box), text: '可控制'),
      const Tab(icon: Icon(Icons.check_box_outline_blank), text: '仅查看'),
    ];

    return DefaultTabController(
      length: _kTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text(this._title),
          backgroundColor: Colors.black,
          // If `TabController controller` is not provided, then a
          // DefaultTabController ancestor must be provided instead.
          // Another way is to use a self-defined controller, c.f. "Bottom tab
          // bar" example.
          bottom: TabBar(
            tabs: _kTabs,
          ),
        ),
        body: TabBarView(
          children: _kTabPages,
        ),
      ),
    );
  }
}

List _group_control = [];
List _group_joined = [];

enum _widget_type { set, get }

class _group_list_widget extends StatelessWidget {
  var _pageparam;
  BuildContext _context;
  _widget_type _wgtype;

  _group_list_widget(this._context, this._pageparam, this._wgtype);

  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      leading: Icon(
        Icons.group,
        size: 32,
      ),
      contentPadding: EdgeInsets.only(left: 20),
      title: Text(
        ret["group_name"].toString(),
        style: Config.Text_Style_default,
      ),
      subtitle: Text(
        ret["gid"].toString(),
        style: Config.Text_Style_default,
      ),
      onTap: () {
        if (this._wgtype == _widget_type.get) {
          Windows.Open(this._context, GroupSettingGet("查看本群设定", this._pageparam));
        } else if (this._wgtype == _widget_type.set) {
          Windows.Open(this._context, GroupFunctionSelect("群机器人设定", this._pageparam));
        }
      },
      trailing: Icon(Icons.keyboard_arrow_right),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}
