import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';

class Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _help();
}

class _help extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("帮助"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 20, right: 20),
        children: [
          Text("1.找到Acfur机器人",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    如果你没有添加机器人为好友，你可以在有Acfur智能姬的群中直接发起私聊，如果你所有加入的群中都没有Acfur智能姬存在，你也可以直接添加智能姬为好友。\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("2.发送acfur登录",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    在与机器人的私聊界面中发送“acfur登录”，机器人就会返回“登录码”给您，登录码一般为9-12位的CRC加密数字\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("3.填写登录码",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    在你收到登录码之后，将登录码填写至登录框的“登录码”输入栏中，点击登录即可登入系统\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("注意事项：",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    请注意哦~要获取登录码只能私聊，不要在群里发送登录两个字哦~机器人不会对群中的“登录”两个字有回应哦~",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text(
            "    另外，如果遇到登陆问题，可以在登陆界面中点击“登陆遇到困难”加入开发群",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text(
            "    如果遇到使用上的问题或者有什么建议或者想法，请在APP“我的”页面最下方点击“反馈群”,或者手动搜索群号：542749156，向我们反馈",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
        ],
      ),
    );
  }
}
