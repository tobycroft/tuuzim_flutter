import 'dart:io';

import 'package:event_hub/event_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:tuuzim_flutter/app/index1/index1.dart';
import 'package:tuuzim_flutter/app/index2/index2.dart';
import 'package:tuuzim_flutter/app/index3/index3.dart';
import 'package:tuuzim_flutter/app/index4/index4.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:tuuzim_flutter/config/event.dart';
import 'package:tuuzim_flutter/config/style.dart';
import 'package:tuuzim_flutter/data/friend/friend_info.dart';
import 'package:tuuzim_flutter/data/group/group_info.dart';
import 'package:tuuzim_flutter/extend/websocket/websocket.dart';
import 'package:tuuzim_flutter/extend/websocket/ws_router.dart';

void main() async {
  if (Platform.isAndroid) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  }
  runApp(MyApp());
}

final JPush jpush = new JPush();

final EventHub eventhub = EventHub();

final upload_progress = FlutterUploader().progress.listen((progress) {
 // print(progress);
});

final upload_result = FlutterUploader().result.listen((result) {
  print(result);
}, onError: (ex, stacktrace) {
  // ... code to handle error
});

class Init {
  Future<void> init() async {
    await FriendInfo.friend_list();
    await GroupInfo.refresh_list();
  }

  Future<void> initWebsocket() async {
    init_websocket();
    eventhub.on(EventType.Websocket_OnMessage, (message) {
      WsRouter.Route(message);
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      jpush.addEventHandler(onReceiveNotification: (Map<String, dynamic> message) async {
        // print("flutter onReceiveNotification: $message");
        eventhub.fire("JPush_notification", message);
      }, onOpenNotification: (Map<String, dynamic> message) async {
        // print("flutter onOpenNotification: $message");
        eventhub.fire("JPush_landing", message);
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        // print("flutter onReceiveMessage: $message");
        eventhub.fire("JPush_message", message);
      }, onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
        // print("flutter onReceiveNotificationAuthorization: $message");
        eventhub.fire("JPush_auth", message);
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    jpush.setup(
      appKey: "4e43b1eb7ada7e0b153addc8", //你自己应用的 AppKey
      channel: "developer-default",
      production: true,
      debug: true,
    );
    jpush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
    });
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TuuzIM',
      darkTheme: ThemeData.dark().copyWith(
        dividerTheme: DividerThemeData(
          color: Colors.black12,
          thickness: 0.5,
          space: 0.5,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
        ),
      ),
      theme: ThemeData(
        // primaryColor: Colors.grey,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Style.LightGrey,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.white54,
          shadowColor: Colors.transparent,
          actionsIconTheme: IconThemeData(color: Colors.black),
          // textTheme: TextTheme(
          //   title: TextStyle(
          //     color: Colors.black,
          //     fontSize: 22,
          //   ),
          // ),
          iconTheme: IconThemeData(color: Colors.black),
          centerTitle: true,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(backgroundColor: Style.LightGrey),
        dividerTheme: DividerThemeData(
          color: Style.LightGrey,
          thickness: 0.3,
          space: 0.5,
        ),
        backgroundColor: Colors.white,
      ),
      home: BotomeMenumPage(),
    );
  }
}

/**
 * 有状态StatefulWidget
 *  继承于 StatefulWidget，通过 State 的 build 方法去构建控件
 */
class BotomeMenumPage extends StatefulWidget {
  BotomeMenumPage();

  //主要是负责创建state
  @override
  BotomeMenumPageState createState() => BotomeMenumPageState();
}

/**
 * 在 State 中,可以动态改变数据
 * 在 setState 之后，改变的数据会触发 Widget 重新构建刷新
 */
class BotomeMenumPageState extends State<BotomeMenumPage> {
  BotomeMenumPageState();

  @override
  List<Widget> pages = List();

  @override
  void initState() {
    Init().init();
    Init().initWebsocket();
    Init().initPlatformState();
    super.initState();

    pages..add(Index1("TuuzIM"))..add(Index2("联系人"))..add(Index3("发现"))..add(Index4("我的"));
  }

  @override
  Widget build(BuildContext context) {
    //构建页面
    return buildBottomTabScaffold();
  }

  //当前显示页面的
  int currentIndex = 0;

  //底部导航栏显示的内容
  final List<BottomNavigationBarItem> bottomNavItems = [
    BottomNavigationBarItem(
      backgroundColor: Colors.blue,
      icon: Icon(Icons.maps_ugc),
      label: "聊天",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[600],
      icon: Icon(Icons.person_pin),
      label: "联系人",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[800],
      icon: Icon(Icons.disc_full),
      label: "发现",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[900],
      icon: Icon(Icons.person),
      label: "我的",
    ),
  ];

  //点击导航项是要显示的页面

  Widget buildBottomTabScaffold() {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: bottomNavItems,
        currentIndex: currentIndex,
        //所以一般都是使用fixed模式，此时，导航栏的图标和标题颜色会使用fixedColor指定的颜色，
        // 如果没有指定fixedColor，则使用默认的主题色primaryColor
        type: BottomNavigationBarType.fixed,
        //底部菜单点击回调
        onTap: (index) {
          _changePage(index);
        },
      ),
      //对应的页面
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
    );
  }

  /*切换页面*/
  void _changePage(int index) {
    /*如果点击的导航项不是当前项  切换 */
    if (index != currentIndex) {
      setState(() {
        currentIndex = index;
      });
    }
  }
}
