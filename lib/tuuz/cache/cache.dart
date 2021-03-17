import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ok_image/ok_image.dart';
import 'package:tuuzim_flutter/config/config.dart';

class CacheImage {
  static network(dynamic img, double w, double h) {
    if (img == null) {
      return DefaultImage(w, h);
    } else {
      return OKImage(
        url: img.toString(),
        width: w,
        height: h,
        loadingWidget: DefaultImage(w, h),
        timeout: Duration(seconds: 5),
        fit: BoxFit.cover,
      );
    }
  }

  static Image DefaultImage(double w, double h) {
    return Image.asset(
      Config.default_image,
      width: w,
      height: h,
      fit: BoxFit.cover,
    );
  }
}
