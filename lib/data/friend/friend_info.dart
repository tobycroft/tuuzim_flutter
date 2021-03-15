import 'dart:convert';

import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/data/friend/url_friend.dart';
import 'package:tuuzim_flutter/model/FriendModel.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';
import 'package:tuuzim_flutter/tuuz/storage/storage.dart';

class FriendInfo {
  static Future<dynamic> friend_info(dynamic fid) async {
    var data = await FriendModel.Api_find(fid);
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
      if (await FriendModel.Api_find(element["uid"]) != null) {
        await FriendModel.Api_delete(element["uid"]);
      }
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
}
