import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index2/group_setting/url_group_setting.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/net/ret.dart';
import 'package:tuuzim_flutter/tuuz/toasts/toast.dart';

class GroupSettingSet extends StatefulWidget {
  var _pageparam;
  String _title;

  GroupSettingSet(this._title, this._pageparam);

  @override
  _GroupSettingSet createState() => _GroupSettingSet(this._title, this._pageparam);
}

List<Widget> _setting = [
  ListTile(
    leading: Icon(Icons.build),
    title: Text("等待数据载入"),
  )
];

Map _data = {};

class _GroupSettingSet extends State<GroupSettingSet> {
  var _pageparam;
  String _title;

  _GroupSettingSet(this._title, this._pageparam);

  @override
  void initState() {
    get_setting(context);
    super.initState();
  }

  Future<void> get_setting(BuildContext context) async {
    Map<String, String> post = await AuthAction().LoginObject();
    post["gid"] = this._pageparam["gid"].toString();
    String ret = await Net.Post(Config.Url, Url_group_setting.Group_Setting_Get, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        _data = json["data"];
        _setting.clear();
        int i = 0;
        _data.forEach((key, value) {
          switch (_data[key]["type"].toString()) {
            case "bool":
              {
                String str = "否";
                if (_data[key]["value"] == 1) {
                  str = "是";
                  _data[key]["value"] = true;
                } else {
                  _data[key]["value"] = false;
                }
                _setting.add(ListTile(
                  leading: Icon(Icons.offline_pin),
                  title: Text(_data[key]["name"].toString()),
                  subtitle: Text(str),
                  trailing: Switch(
                    value: _data[key]["value"],
                    onChanged: (value) async {
                      if (value == false) {
                        await set_setting(context, key, 0);
                      } else {
                        await set_setting(context, key, 1);
                      }
                      get_setting(context);
                    },
                  ),
                ));
                break;
              }

            case "int":
              {
                _setting.add(
                  ListTile(
                    leading: Icon(Icons.confirmation_number),
                    title: Text(_data[key]["name"].toString()),
                    subtitle: TextField(
                      keyboardType: TextInputType.number,
                      // style: Theme.of(context).textTheme.headline4,
                      decoration: InputDecoration(hintText: "输入一个数字"),
                      controller: TextEditingController.fromValue(TextEditingValue(text: _data[key]["value"].toString())),
                      onChanged: (value) async {
                        _data[key]["value"] = value.toString();
                      },
                    ),
                    trailing: RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text(
                        "修改",
                      ),
                      onPressed: () async {
                        await set_setting(context, key, _data[key]["value"]);
                        get_setting(context);
                      },
                    ),
                  ),
                );
                break;
              }

            case "string":
              {
                _setting.add(ListTile(
                  leading: Icon(Icons.textsms),
                  title: Text(_data[key]["name"].toString()),
                  subtitle: TextField(
                    maxLines: 3,
                    keyboardType: TextInputType.number,
                    // style: Theme.of(context).textTheme.headline4,
                    decoration: InputDecoration(
                        hintText: "输入一个数字",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        )),
                    controller: TextEditingController.fromValue(TextEditingValue(text: _data[key]["value"].toString())),
                    onChanged: (value) async {
                      _data[key]["value"] = value.toString();
                    },
                  ),
                  trailing: RaisedButton(
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text(
                      "修改",
                    ),
                    onPressed: () async {
                      await set_setting(context, key, _data[key]["value"]);
                      get_setting(context);
                    },
                  ),
                ));
                break;
              }

            default:
              {
                _setting.add(ListTile(
                  leading: Icon(Icons.build),
                  title: Text(_data[key]["name"].toString()),
                  subtitle: Text(_data[key]["value"].toString()),
                ));
                break;
              }
          }
        });
        setState(() {});
      }
    }
  }

  Future<void> set_setting(BuildContext context, String key, dynamic value) async {
    Map<String, String> post = await AuthAction().LoginObject();
    post["gid"] = this._pageparam["gid"].toString();
    post["key"] = key.toString();
    post["value"] = value.toString();
    String ret = await Net.Post(Config.Url, Url_group_setting.Group_Setting_Set, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (Ret.Check_isok(context, json)) {
        Toasts.Show(json["echo"].toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
      ),
      body: ListView.builder(
        itemBuilder: (BuildContext con, int index) => _setting[index],
        itemCount: _setting.length,
      ),
    );
  }
}
