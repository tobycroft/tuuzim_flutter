import "package:flutter/material.dart";

class ProgressDemo extends StatefulWidget {
  ProgressDemo({Key key}) : super(key: key);

  @override
  _ProgressDemoState createState() => _ProgressDemoState();
}

class _ProgressDemoState extends State<ProgressDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("flutter progress demo"),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        alignment: Alignment.topCenter,
        child: FlatButton(
          child: Text("进度"),
          color: Colors.blue,
          onPressed: () {
            return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  title: Text("上传中..."),
                  content: LinearProgressIndicator(
                    value: 0.3,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    backgroundColor: Colors.blue,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
