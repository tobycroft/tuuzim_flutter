
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index4/setting/account_safe/account_safe.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class AppSetting extends StatefulWidget {
  String _title;

  AppSetting(this._title);

  _AppSetting createState() => _AppSetting(this._title);
}

class _AppSetting extends State<AppSetting> {
  String _title;

  _AppSetting(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
      ),
      body:          Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "账号与安全",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Windows.Open(context, AccountSafe("账号与安全"));
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "新消息提醒",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "勿扰模式",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "聊天",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "隐私",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "通用",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "关于微信",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "帮助与反馈",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: Colors.white10,
            height: 60,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "切换账号",
                  style: Config.Text_style_Name.copyWith(
                    color: Colors.white60,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: Colors.white10,
            height: 60,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  "退出",
                  style: Config.Text_style_Name.copyWith(
                    color: Colors.white60,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
