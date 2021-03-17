import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ok_image/ok_image.dart';

class CacheImage {
  static OKImage network(dynamic img, double w, double h) {
    if (img == null) {
      return OKImage(
        url: "images/logo.png",
        width: w,
        height: h,
        timeout: Duration(seconds: 20),
        fit: BoxFit.cover,
      );
    } else {
      return OKImage(
        url: img.toString(),
        width: w,
        height: h,
        timeout: Duration(seconds: 20),
        fit: BoxFit.cover,
      );
    }
  }
}
