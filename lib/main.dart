import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuuzim_flutter/app/index1/index1.dart';
import 'package:tuuzim_flutter/app/index2/index2.dart';
import 'package:tuuzim_flutter/app/index3/index3.dart';
import 'package:tuuzim_flutter/app/index4/index4.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

void main() async {
  Init().init();
  runApp(MyApp());
}

class Init {
  void init() async {
    // PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // print(packageInfo.appName);
    // print(packageInfo.version);
  }

  void is_login() async {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.black,
          centerTitle: true,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

final JPush jpush = new JPush();

/**
 * 在 State 中,可以动态改变数据
 * 在 setState 之后，改变的数据会触发 Widget 重新构建刷新
 */
class BotomeMenumPageState extends State<BotomeMenumPage> {
  BotomeMenumPageState();

  String debugLable = 'Unknown';

  @override
  void initState() {
    ///初始化，这个函数在生命周期中只调用一次
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "f7ec188c8df31cdca3d50b22", //你自己应用的 AppKey
      channel: "developer-default",
      production: true,
      debug: true,
    );
    jpush.applyPushAuthority(new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
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
      icon: Icon(Icons.android_rounded),
      label: "机器人控制",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[600],
      icon: Icon(Icons.desktop_windows),
      label: "群管理",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[800],
      icon: Icon(Icons.camera),
      label: "发现",
    ),
    BottomNavigationBarItem(
      backgroundColor: Colors.blue[900],
      icon: Icon(Icons.person),
      label: "我的",
    ),
  ];

  //点击导航项是要显示的页面
  final pages = [Index1("机器人列表"), Index2("群列表"), Index3("发现"), Index4("我的")];

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
      body: pages[currentIndex],
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
