class ChatGen {
  static String ChatId(int a, int b) {
    if (a > b) {
      return b.toString() + "_" + a.toString();
    } else {
      return a.toString() + "_" + b.toString();
    }
  }
}
