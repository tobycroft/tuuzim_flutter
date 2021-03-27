import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuuzim_flutter/app/login/help/help.dart';
import 'package:tuuzim_flutter/app/login/register/register.dart';
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

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _login();
}

class _login extends State<Login> {
  String username;
  String password;

  @override
  Widget build(BuildContext context) {
    var uid_controller = new TextEditingController(text: "");
    var password_controller = new TextEditingController(text: "");
    uid_controller.addListener(() {
      this.username = uid_controller.text;
    });

    //这里双向绑定简直是太蛋疼了
    password_controller.addListener(() {
      this.password = password_controller.text;
    });
    void initold() async {
      Map user = await UserModel.Api_find();
      if (user != null) {
        uid_controller.text = user["username"].toString();
        password_controller.text = user["password"].toString();
      }
    }

    initold();
    // void initState() {
    //   setState(() {
    //     var _con = new TextEditingController(text: "");
    //   });
    // }

    close_win() async {}

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          "登录",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: null,
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
                    controller: uid_controller,
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
                      labelText: "请输入你的账号",
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
                    controller: password_controller,
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
                    child: Text('登录'),
                    onPressed: () async {
                      Map<String, String> post = {
                        "username": this.username,
                        "password": this.password,
                      };
                      String ret = await Net.Post(Config.Url, Url.login, null, post, null);
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
                        Alert.Confirm(context, "登录成功", json["data"]["uid"].toString() + "欢迎回来！", Windows.Close(context));
                      } else {
                        Alert.Confirm(context, "登录失败", json["echo"], null);
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FlatButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 50,
                    shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Text('注册'),
                    onPressed: () async {
                      Windows.Open(context, Register());
                    },
                  ),
                ],
              ),
            ),
          ),
          onWillPop: close_win),
    );
  }
}
