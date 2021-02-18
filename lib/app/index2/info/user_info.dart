import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/cache/cache.dart';

class UserInfo extends StatefulWidget {
  String _title;
  var _pageparam;

  UserInfo(this._title, this._pageparam);

  _UserInfo createState() => _UserInfo(this._title, this._pageparam);
}

class _UserInfo extends State<UserInfo> {
  String _title;
  var _pageparam;

  _UserInfo(this._title, this._pageparam);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            height: 150,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                    // color: Colors.white10,
                    ),
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 80,
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CacheImage.network(this._pageparam["face"], 70, 70),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 110),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this._pageparam["uname"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                      Text(
                        "昵称：" + this._pageparam["nickname"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "TuIM ID：" + this._pageparam["fid"].toString(),
                        style: Config.Text_style_Name.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            tileColor: Colors.black38,
            leading: Text(
              "朋友圈",
              style: Config.Text_style_Name.copyWith(
                color: Colors.white60,
              ),
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: null,
            onTap: () {},
          ),
          SizedBox(
            height: 10,
          ),
          FlatButton(
            color: Colors.black38,
            height: 60,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.question_answer,
                  color: Colors.white60,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "发送消息",
                  style: Config.Text_style_Name.copyWith(
                    color: Colors.white60,
                  ),
                )
              ],
            ),
          ),
          FlatButton(
            color: Colors.black38,
            height: 60,
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.video_call,
                  color: Colors.white60,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "实时语音",
                  style: Config.Text_style_Name.copyWith(
                    color: Colors.white60,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
