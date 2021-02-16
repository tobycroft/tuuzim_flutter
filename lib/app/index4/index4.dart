import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index4/about/about.dart';
import 'package:tuuzim_flutter/app/index4/balance_record/balance_record.dart';
import 'package:tuuzim_flutter/app/index4/login_record/login_record_list.dart';
import 'package:tuuzim_flutter/app/index4/url_index4.dart';
import 'package:tuuzim_flutter/config/auth.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/res.dart';
import 'package:tuuzim_flutter/config/url.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:package_info/package_info.dart';
import 'package:r_upgrade/r_upgrade.dart';

class Index4 extends StatefulWidget {
  String _title;

  Index4(this._title);

  @override
  _Index4 createState() => _Index4(this._title);
}

double _percent = 0;

class _Index4 extends State<Index4> {
  String _title;

  _Index4(this._title);

  @override
  void initState() {
    get_user_info();
    get_user_balance();

    super.initState();
    RUpgrade.stream.listen((DownloadInfo info) {
      setState(() {
        _percent = info.percent;
      });
    });
  }

  @override
  Future<void> get_user_info() async {
    Map<String, String> post = await AuthAction().LoginObject();
    var ret = await Net.Post(Config.Url, Url_Index4.User_info, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (json["code"] == 0) {
        _user_info = json["data"];
        setState(() {});
      } else {
        Alert.Error(context, json["data"], () {});
      }
    } else {
      setState(() {
        _user_info = {
          "uname": "请先登录",
          "qq": "",
        };
      });
    }
  }

  Future<void> get_user_balance() async {
    Map<String, String> post = await AuthAction().LoginObject();
    var ret = await Net.Post(Config.Url, Url_Index4.User_balance, null, post, null);
    Map json = jsonDecode(ret);
    if (Auth.Return_login_check(context, json)) {
      if (json["code"] == 0) {
        _user_balance = json["data"];
        setState(() {});
      } else {
        Alert.Error(context, json["data"], () {});
      }
    } else {
      setState(() {
        _user_balance = {
          "balance": 0,
        };
      });
    }
  }

  Map _user_info = {
    "uname": "请先登录",
    "qq": "",
  };
  Map _user_balance = {
    "balance": 0,
  };

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this._title),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: ListView(
        children: [
          Container(
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.blue,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      Res.Index4_head_img,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _user_info["uname"].toString(),
                        style: Config.Text_style_Name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _user_info["qq"].toString(),
                        style: Config.Text_style_Name,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "长按>退出账号",
                        style: Config.Text_style_Name,
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Auth.Check_and_goto_login(context);
                  },
                  onLongPress: () async {
                    Storage.Delete("__token__");
                    Alert.Confirm(context, "成功退出", "", () {});
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.keyboard_arrow_right),
                  ),
                ),
              ],
            ),
          ),
          GridView.count(
              padding: EdgeInsets.all(0),
              physics: new NeverScrollableScrollPhysics(),
              //增加
              shrinkWrap: true,
              //增加
              crossAxisCount: 3,
              children: <Widget>[
                FlatButton(
                  color: Colors.deepPurpleAccent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.settings,
                        size: 80,
                      ),
                      Text(
                        "登录记录",
                        style: Config.Text_Style_default,
                      )
                    ],
                  ),
                  onPressed: () async {
                    Windows.Open(context, LoginRecordList("登录记录", _user_info));
                  },
                ),
                FlatButton(
                  color: Colors.green,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restore_page,
                        size: 80,
                      ),
                      Text(
                        "更新版本",
                        style: Config.Text_Style_default,
                      )
                    ],
                  ),
                  onPressed: () async {
                    PackageInfo info = await PackageInfo.fromPlatform();
                    int version_code = int.tryParse(info.buildNumber);
                    Map<String, String> post = {
                      "platform": Platform.operatingSystem.toString(),
                      "dart": Platform.version.toString(),
                      "system": Platform.operatingSystemVersion.toString(),
                      "version": info.version,
                      "version_code": version_code.toString(),
                      "package_name": info.packageName,
                      "appname": info.appName,
                    };

                    String ret = await Net.Post(Config.Url, Url.Update_path, null, post, null);
                    Map json = jsonDecode(ret);
                    if (json["code"] == 0) {
                      Map data = json["data"];

                      if (version_code < int.parse(data["version"])) {
                        String upgrade_text = "";
                        upgrade_text += "当权版本：";
                        upgrade_text += info.version.toString() + "\r\n";
                        upgrade_text += "有新版本：";
                        upgrade_text += data["show_ver"].toString() + "\r\n";

                        upgrade_text += "更新内容：\r\n";
                        upgrade_text += data["upgrade_text"].toString() + "\r\n";

                        upgrade_text += "更新日期:" + data["date"].toString();

                        Alert.Simple(context, "有新的更新", upgrade_text, () {
                          RUpgrade.upgrade(
                            data["url"].toString(),
                            fileName: data["file"].toString(),
                            isAutoRequestInstall: true,
                            notificationStyle: NotificationStyle.speechAndPlanTime,
                            useDownloadManager: false,
                          );
                        });
                      } else {
                        Alert.Confirm(context, "没有新的更新了", "", () {});
                      }
                    }
                  },
                ),
                FlatButton(
                  color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.weekend,
                        size: 80,
                      ),
                      Text(
                        "关于我们",
                        style: Config.Text_Style_default,
                      )
                    ],
                  ),
                  onPressed: () async {
                    Windows.Open(context, Index4_about());
                  },
                ),
              ]),
          Column(
            children: [
              LiquidLinearProgressIndicator(
                value: _percent,
                // Defaults to 0.5.
                valueColor: AlwaysStoppedAnimation(Colors.green),
                // Defaults to the current Theme's accentColor.
                backgroundColor: Colors.transparent,
                // Defaults to the current Theme's backgroundColor.
                borderColor: Colors.blue,
                borderWidth: 0.0,
                borderRadius: 0.0,
                direction: Axis.horizontal,
                // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                center: Text(_percent.toString()),
              ),
              ListTile(
                leading: Icon(
                  Icons.account_balance_wallet,
                  color: Colors.black,
                  size: 48,
                ),
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("积分"),
                subtitle: Text(_user_balance["balance"].toString()),
                onTap: () {
                  Windows.Open(context, Balance_record("积分记录"));
                },
              ),
            ],
          ),
          Container(
            color: Colors.blueGrey,
          ),
        ],
      ),
    );
  }
}
