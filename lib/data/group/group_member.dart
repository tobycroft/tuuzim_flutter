import 'dart:convert';

import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/data/group/url_group.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/model/GroupMemberModel.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';

class GroupMember {
  static Future<void> refresh_member() async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, UrlGroup.GroupMember, null, post, null);
    Map json = jsonDecode(ret);
    if (json["code"] == 0) {
      var _data = json["data"];
      _data.forEach((element) async {
        if (await GroupMemberModel.Api_find(element["uid"]) != null) {
          await GroupMemberModel.Api_delete(element["uid"]);
        }
        GroupMemberModel.Api_insert(
          element["uid"],
          element["gid"],
          element["uname"],
          element["face"],
          element["role"],
          element["card"],
        );
      });
    }
  }

  static Future<Map> get_info(dynamic uid) async {
    var data = await GroupMemberModel.Api_find(int.tryParse(uid.toString()));
    if (data != null) {
      return data;
    }
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, UrlGroup.Get, null, post, null);
    Map json = jsonDecode(ret);
    if (json["code"] == 0) {
      var element = json["data"];
      await GroupMemberModel.Api_delete(element["uid"]);
      GroupMemberModel.Api_insert(
        element["uid"],
        element["gid"],
        element["uname"],
        element["face"],
        element["role"],
        element["card"],
      );
    }
  }
}
