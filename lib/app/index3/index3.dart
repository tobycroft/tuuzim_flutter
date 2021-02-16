import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/app/index3/upload_robot/upload_robot.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class Index3 extends StatefulWidget {
  String _title;

  Index3(this._title);

  _Index3 createState() => _Index3(this._title);
}

class _Index3 extends State<Index3> {
  String _title;

  _Index3(this._title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          FlatButton(
            color: Colors.black87,
            splashColor: Colors.white,
            textColor: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_alt,
                  size: 80,
                ),
                Text(
                  "提交一个机器人",
                  style: Config.Text_style_main_page,
                ),
              ],
            ),
            onPressed: () async {
              Windows.Open(context, Upload_robot("提交机器人"));
            },
          ),
        ],
      ),
    );
  }
}
