import 'dart:ui';

import 'package:cache_image/cache_image.dart' as iiage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CacheImage {
  static FadeInImage network(dynamic img, double w, double h) {
    if (img == null) {
      return FadeInImage(
        fit: BoxFit.cover,
        width: w,
        height: h,
        placeholder: AssetImage("images/logo.png"),
        image: iiage.CacheImage("images/logo.png"),
      );
    } else {
      return FadeInImage(
        fit: BoxFit.cover,
        width: w,
        height: h,
        placeholder: AssetImage("images/logo.png"),
        image: iiage.CacheImage(img.toString()),
      );
    }
  }
}
