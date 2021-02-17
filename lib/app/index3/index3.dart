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
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text(
          this._title,
          style: Config.Text_style_title,
        ),
      ),
      body:          Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            leading: Icon(
              Icons.camera,
              color: Colors.greenAccent,
              size: 32,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "朋友圈",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            leading: Icon(
              Icons.qr_code_scanner,
              color: Colors.red,
              size: 32,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "扫码",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            tileColor: Colors.white10,
            leading: Icon(
              Icons.error_outline,
              color: Colors.purple,
              size: 32,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white38,
            ),
            title: Text(
              "周围的人",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
            },
          ),

        ],
      ),
    );
  }
}
