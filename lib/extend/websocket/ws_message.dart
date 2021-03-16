class WsMessage {
  static Map init(dynamic uid, token) {
    Map<String, dynamic> data = {
      "type": "init",
      "data": {
        "uid": uid,
        "token": token,
      },
    };
    return data;
  }
}
