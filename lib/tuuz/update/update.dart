import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:package_info/package_info.dart';
import 'package:r_upgrade/r_upgrade.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/config/url.dart';
import 'package:tuuzim_flutter/tuuz/alert/ios.dart';
import 'package:tuuzim_flutter/tuuz/net/net.dart';

class Update {
  update(BuildContext context) async {
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
  }
}
