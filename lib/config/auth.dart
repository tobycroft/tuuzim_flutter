import 'package:flutter/cupertino.dart';
import 'package:tuuzim_flutter/app/login/login.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Auth {
  static Future<bool> Check_login() async {
    bool uid = await Storage.Has("__uid__");
    bool token = await Storage.Has("__token__");
    if (uid && token) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> Check_and_goto_login(BuildContext context) async {
    bool uid = await Storage.Has("__uid__");
    bool token = await Storage.Has("__token__");
    if (uid && token) {
      return true;
    } else {
      Goto_Login(context);
      return false;
    }
  }

  static bool Return_login_check_and_Goto(BuildContext context, Map json) {
    if (json["code"] == -1) {
      Clear_Login();
      Windows.Open(context, Login());
      return false;
    } else {
      return true;
    }
  }

  static bool Return_login_check(BuildContext context, Map json) {
    if (json["code"] == -1) {
      Clear_Login();
      return false;
    } else {
      return true;
    }
  }

  static void Goto_Login(BuildContext context) async {
    await Windows.Open(context, Login());
  }

  static void Clear_Login() async {
    await Storage.Delete("__uid__");
    await Storage.Delete("__token__");
    eventhub.fire(EventType.Logout);
  }
}
