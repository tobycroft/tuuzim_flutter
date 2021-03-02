import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/toasts/toast.dart';

class AccountSafe extends StatefulWidget {
  String _title;

  AccountSafe(this._title);

  _AccountSafe createState() => _AccountSafe(this._title);
}

class _AccountSafe extends State<AccountSafe> {
  String _title;

  _AccountSafe(this._title);

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
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          FlatButton(
            height: 60,
            color: Colors.white10,
            focusColor: Colors.white10,
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "登录账号",
                  style:
                      Config.Text_Style_default.copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      "18650082357",
                      style: Config.Text_Style_default.copyWith(
                          color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white38,
                    ),
                  ],
                )
              ],
            ),
            onPressed: () async {
              Toasts.Show("xxxcccc");
            },
          ),
          Divider(
            height: 1,
          ),
          Container(
            width: 750,
            height: 60,
            color: Colors.white10,
            padding: EdgeInsets.only(left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "手机号",
                  style:
                      Config.Text_Style_default.copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      color: Colors.green,
                      size: 14,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "18650082357",
                      style: Config.Text_Style_default.copyWith(
                          color: Colors.white),
                    ),
                    SizedBox(width: 5),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white38,
                    ),
                  ],
                )
              ],
            ),
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "密码",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "登录设备管理",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {},
          ),
          Divider(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "安全中心",
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              "如果遇到账号被盗，无法登陆等问题，可以前往安全中心",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 12,
                height: 3,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
