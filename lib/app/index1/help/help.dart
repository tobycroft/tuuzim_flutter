import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';

class Index_Help extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _index_help();
}

class _index_help extends State<Index_Help> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("APP帮助"),
        leading: BackButton(),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          Text(
            "使用说明",
            style: TextStyle(fontSize: 36),
          ),
          Text("1.首页会显示什么内容？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    首页是你的机器人列表，你拥有的机器人将会在下面的列表中显示\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("2.如何绑定机器人？？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    你可以在第三页中查看所有未绑定的机器人，并将机器人与你当前的账号进行绑定，绑定后机器人的归属权将会全权移交给你\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("3.我是否可以将我的机器人共享给别人用？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    你可以在绑定机器人后，将你的机器人开放给公网其他用户使用，当你开放机器人对公网显示后，机器人将会转变为共享机器人\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("4.共享机器人说明，什么是共享机器人？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    共享机器人是对公网用户开放的机器人，如果需要使用共享机器人你可以在机器人信息中发起共享申请，共享机器人的功能没有独享机器人丰富，并且每个独享机器人的共享账号主每人只能绑定3个群（防止恶意拉多个群导致封禁）\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("5.独享机器人有什么优势？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    独享机器人的帐号主可以绑定无限数量的群，并且独享机器人功能不受限，拥有机器人全部权限，对机器人本体的操作无需账号组内的其他用户同意\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("6.从独享机器人转为共享机器人需要准备什么吗？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    当你希望操作你的机器人从独享转为共享机器人前，请先务必先添加你所在的群，假设你是独享机器人，在转换机器人功能前，"
            "你已经绑定了10个群，那么在机器人转换后，你将无法再绑定任何一个群（因为共享机器人只能绑定3个群），但是这不会影响你之前已经绑定过的群\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("7.我是否可以从独享机器人转换为共享机器人？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    如果机器人再转为共享机器人后，没有人加入你的共享组，那么你可以直接将机器人转换回独享机器人，"
            "如果已经有人加入了你的共享机器人组，那么你必须要通过组内投票，得到100%用户的同意后才可以进行转换，"
            "当然作为号主可以强行转换，但是号主及该机器人都将失去再次共享的权限，"
            "在从共享机器人重新转回独享机器人后，机器人的可用时间加成也会一并回收，如果时间超出了共享机器人的使用时间，"
            "则机器人将会立即失效\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("8.号主如果需要共享机器人，有什么义务需要注意吗？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    号主需要时刻关注自己的账号情况，账号出现黑号等情况需要尽快修复，每个加入共享组的机器人将会为号主以及该机器人进行动态打分，"
            "分数越高，机器人的排名将会越靠前，并且在周月年度明星机器人排行上将会列居前位，反之，如果平均分降低到3分以下将会被取消共享资格，请各位号主珍惜自己的账号\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("9.官方共享机器人与玩家共享机器人有什么区别吗？",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    官方共享机器人有专人维护，出现账号级别的故障后恢复时间较短\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text("注意事项：",
              style: TextStyle(
                fontSize: Config.Font_Size,
              )),
          Text(
            "    1.当你发起了一次机器人申请后，在申请通过或者驳回前将无法再次发起申请\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text(
            "    2.另外，如果遇到登陆问题，可以在登陆界面中点击“登陆遇到困难”加入开发群\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text(
            "    3.因为不可抗力因素，如果机器人出现了永久封禁等情况，则当作报废处理，需要重新换新机器人\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
          Text(
            "    4.如果遇到使用上的问题或者有什么建议或者想法，请在APP“我的”页面最下方点击“反馈群”,或者手动搜索群号：542749156，向我们反馈\r\n",
            style: TextStyle(fontSize: Config.Font_size_text),
          ),
        ],
      ),
    );
  }
}
