import 'package:tuuzim_flutter/tuuz/storage/storage.dart';

class AuthAction {
  LoginObject() async {
    Map<String, String> post = {};
    post["uid"] = await Storage.Get("__uid__");
    post["token"] = await Storage.Get("__token__");
    return post;
  }
}
