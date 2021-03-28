class Time {
  static int now() {
    return ((new DateTime.now().millisecondsSinceEpoch) / 1000).round();
  }

  static String Int2Date(int timing) {
    var strtime = DateTime.fromMillisecondsSinceEpoch(timing * 1000);
    var sdatetime = strtime.toLocal().toString().substring(0, 16);

    return sdatetime;
  }

  static String Int2Date_auto_str(int timing) {
    int time = now() - timing;
    print(time);
    if (time < 600) {
      return "刚刚";
    } else if (time < 3600) {
      return (time / 3600).round().toString() + "分钟";
    } else if (time < 86400) {
      return (time / 3600).round().toString() + "小时";
    } else {
      return Int2Date(timing);
    }
  }
}
