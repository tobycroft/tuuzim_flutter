import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/res.dart';
import 'package:tuuzim_flutter/config/url.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/model/UserModel.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/button/button.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Register extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Register();
}

class _Register extends State<Register> {
  String username;
  String phone;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "注册账号",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: BackButton(),
        actions: [
          // IconButton(
          //     icon: Icon(
          //       Icons.help,
          //       color: Colors.white,
          //     ),
          //     color: Colors.white,
          //     onPressed: () {
          //       Windows.Open(context, Help());
          //     })
        ],
      ),
      body: WillPopScope(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.white,
              accentColor: Colors.amber,
            ),
            child: Container(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage(Res.Login_BG), fit: BoxFit.cover)),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: ListView(
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      filled: true,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "账号",
                      labelText: "用于登录的账号（可中文）",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (String value) {
                      this.username = value;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      filled: true,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "手机号",
                      labelText: "仅作为恢复密码用（不可搜索）",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (String value) {
                      this.phone = value;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    cursorColor: Colors.white,
                    textCapitalization: TextCapitalization.words,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hoverColor: Colors.white,
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 2.0, color: Colors.white),
                      ),
                      filled: true,
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "密码",
                      labelText: "请输入登录密码",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onChanged: (String value) {
                      this.password = value;
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Checkbox(
                        onChanged: (bool value) {
                          // setState(() => this._checkBoxVal = value);
                        },
                        value: true,
                      ),
                      Text(
                        "用户守则",
                        style: TextStyle(
                          fontSize: Config.Font_size_text,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 50,
                    shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Text('注册'),
                    onPressed: () async {
                      Map<String, String> post = {
                        "username": this.username,
                        "phone": this.phone,
                        "password": this.password,
                      };
                      String ret = await Net.Post(Config.Url, Url.Register_simple, null, post, null);
                      var json = jsonDecode(ret);
                      if (json["code"] == 0) {
                        Storage.Set("__uid__", json["data"]["uid"].toString());
                        Storage.Set("__token__", json["data"]["token"].toString());
                        if (await UserModel.Api_find_by_username(this.username) != null) {
                          UserModel.Api_update_by_username(this.username, this.password, json["data"]["uid"].toString(), json["data"]["token"].toString());
                        } else {
                          UserModel.Api_insert(json["data"]["uid"].toString(), json["data"]["token"].toString(), this.username, this.password);
                        }
                        eventhub.fire(EventType.Login);
                        Alert.Confirm(context, "注册成功", json["data"]["uid"].toString() + "欢迎回来！", () {
                          Windows.Close(context);
                          Windows.Close(context);
                        });
                      } else {
                        Alert.Confirm(context, "注册失败", json["echo"], null);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          onWillPop: null),
    );
  }
}
