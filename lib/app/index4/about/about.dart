import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/toasts/toast.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index4_about extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Index4_about();
}

class _Index4_about extends State<Index4_about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于我们"),
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        children: [
          Text(
            "关于GobotQ",
            style: TextStyle(fontSize: 36),
          ),
          Text("1.和Acfur相比GobotQ有什么优势？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    程序更加先进，Acfur只能姬基于PHP开发，GobotQ如其名，采用Golang作为程序语言开发，在APP上，Acfur使用H5开发，GobotQ采用Flutter开发，性能更好，也更加安全\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("2.软件要付钱吗？？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    不用！！！GobotQ的软件是完全免费的，也是永久免费的，可以放心使用\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("3.程序会一直更新吗？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    如果有新的需求就会一直更新的\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("4.如果我选择三方机器人是否要付费？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    共享机器人来自玩家提供的，本平台不支持付费也不对三方机器人提供支持\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("5.有停机的可能吗？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    一般情况不会停，如果出现特殊大环境因素导致停机，那么从停机起机器人会开始计算停机时间，等后面恢复了停机时间会全部补，可以放心！\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("6.软件如果出现BUG要如何反馈呢？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    你可以加入反馈群：542749156，有任何问题可以在群中向我们反馈！\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text("点击复制群号"),
            onPressed: () async {
              Clipboard.setData(ClipboardData(text: "542749156"));
              Toasts.Show("群号已经复制");
            },
          ),
          RaisedButton(
            color: Colors.blue,
            child: Text("点击我加入反馈群"),
            onPressed: () async {
              Windows.Open_url(context, "https://qm.qq.com/cgi-bin/qm/qr?k=spNoTiw49InkjrJgvWFT6zBShx6MdREw&jump_from=webapi");
            },
          ),
        ],
      ),
    );
  }
}
