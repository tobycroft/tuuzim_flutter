import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:tuuzim_flutter/tuuz/win/close.dart';

class UI_Friendlist extends StatelessWidget {
  var _pageparam;
  BuildContext _context;
  String _img_keyname;
  String _title_keyname;
  String _subtitle_keyname;
  String _rightsub_keyname;
  Function open_win;
  VoidCallback onlongpress;

  UI_Friendlist(this._context, this._pageparam, this._img_keyname, this._title_keyname, this._subtitle_keyname, this._rightsub_keyname, this.open_win, this.onlongpress);
  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      leading: CircleAvatar(
        child: Image(image: NetworkImage(ret[this._img_keyname])),
      ),
      title: FlatButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ret[this._title_keyname].toString(),
              style: Config.Text_Style_default,
            ),
            Text(
              ret[this._subtitle_keyname].toString(),
              style: Config.Text_Style_default,
            )
          ],
        ),
        onPressed: () {
          //Todo：短按进入机器人信息
          Windows.Open(this._context, this.open_win(this._pageparam));
        },
        onLongPress: this.onlongpress,
      ),
      trailing: Text(
        ret[this._rightsub_keyname].toString(),
        style: Config.Text_Style_default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}

class UI_Friendlist_without_img extends StatelessWidget {
  var _pageparam;
  BuildContext _context;
  String _title_keyname;
  String _subtitle_keyname;
  String _rightsub_keyname;
  Function open_win;
  VoidCallback onlongpress;

  UI_Friendlist_without_img(this._context, this._pageparam, this._title_keyname, this._subtitle_keyname, this._rightsub_keyname, this.open_win, this.onlongpress);
  Widget _buildTiles(Map ret) {
    if (ret == null) return ListTile();
    return ListTile(
      title: FlatButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              ret[this._title_keyname].toString(),
              style: Config.Text_Style_default,
            ),
            Text(
              ret[this._subtitle_keyname].toString(),
              style: Config.Text_Style_default,
            )
          ],
        ),
        onPressed: () {
          //Todo：短按进入机器人信息
          Windows.Open(this._context, this.open_win(this._pageparam));
        },
        onLongPress: this.onlongpress,
      ),
      trailing: Text(
        ret[this._rightsub_keyname].toString(),
        style: Config.Text_Style_default,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(this._pageparam);
  }
}
