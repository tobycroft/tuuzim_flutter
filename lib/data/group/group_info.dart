import 'dart:convert';

import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/data/group/url_group.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/model/GroupModel.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';

class GroupInfo {
  static Future<void> refresh_list() async {
    Map post = await AuthAction.LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.GroupList, null, post, null);
    Map json = jsonDecode(ret);
    if (json["code"] == 0) {
      var _data = json["data"]["admin"];
      _data += json["data"]["member"];
      _data += json["data"]["other"];
      _data += json["data"]["owner"];
      _data.forEach((element) async {
        if (await GroupModel.Api_find(element["id"]) != null) {
          await GroupModel.Api_delete(element["id"]);
        }
        GroupModel.Api_insert(
          element["id"],
          element["announcement"],
          element["ban_all"],
          element["can_add"],
          element["can_recommend"],
          element["category"],
          element["direct_join_group"],
          element["group_name"],
          element["img"],
          element["introduction"],
          element["max_admin_count"],
          element["max_member_count"],
        );
      });
    }
  }

  static Future<Map> get_info(dynamic gid) async {
    var data = await GroupModel.Api_find(int.tryParse(gid.toString()));
    if (data != null) {
      return data;
    }
    Map post = await AuthAction.LoginObject();
    post["gid"] = gid;
    String ret = await Net.Post(Config.Url, UrlGroup.Get, null, post, null);
    Map json = jsonDecode(ret);
    if (json["code"] == 0) {
      var element = json["data"];
      await GroupModel.Api_delete(element["id"]);
      GroupModel.Api_insert(
        element["id"],
        element["announcement"],
        element["ban_all"],
        element["can_add"],
        element["can_recommend"],
        element["category"],
        element["direct_join_group"],
        element["group_name"],
        element["img"],
        element["introduction"],
        element["max_admin_count"],
        element["max_member_count"],
      );
    }
  }
}
