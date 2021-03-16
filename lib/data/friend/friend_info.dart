import 'dart:convert';

import 'package:tuuzim_flutter/app/index2/url_index2.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/data/friend/url_friend.dart';
import 'package:tuuzim_flutter/extend/authaction/authaction.dart';
import 'package:tuuzim_flutter/main.dart';
import 'package:tuuzim_flutter/model/FriendModel.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';

class FriendInfo {
  static Future<dynamic> friend_info(dynamic fid) async {
    var data = await FriendModel.Api_find(int.tryParse(fid.toString()));
    if (data != null) {
      return data;
    }
    Map<String, String> post = {};
    post["uid"] = await Storage.Get("__uid__");
    post["token"] = await Storage.Get("__token__");
    post["fid"] = fid.toString();
    var ret = await Net.Post(Config.Url, UrlFriend.SimpleInfo, null, post, null);
    var json = jsonDecode(ret);
    if (json["data"] != null) {
      var element = json["data"];
      await FriendModel.Api_delete(element["uid"]);
      await FriendModel.Api_insert(
        element["uid"],
        element["uname"],
        element["nickname"],
        element["face"],
        element["sex"],
        element["telephone"],
        element["remark"],
        element["mail"],
        element["introduction"],
        element["destory"],
        element["destory_time"],
        element["can_pull"],
        element["can_notice"],
      );
      return FriendModel.Api_find(element["uid"]);
    } else {
      return null;
    }
  }

  static Future<void> friend_list() async {
    Map post = await AuthAction().LoginObject();
    String ret = await Net.Post(Config.Url, Url_Index2.Friend_list, null, post, null);
    Map json = jsonDecode(ret);
    if (json["data"] != null) {
      var _data = json["data"];
      _data.forEach((element) async {
        if (await FriendModel.Api_find(element["fid"]) != null) {
          await FriendModel.Api_delete(element["fid"]);
        }
        FriendModel.Api_insert(
          element["fid"],
          element["uname"],
          element["nickname"],
          element["face"],
          element["sex"],
          element["telephone"],
          element["remark"],
          element["mail"],
          element["introduction"],
          element["destory"],
          element["destory_time"],
          element["can_pull"],
          element["can_notice"],
        );
      });
    }
    eventhub.fire(EventType.FriendList_updated);
  }
}
