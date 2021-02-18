import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CacheImage {
  static ExtendedImage network(dynamic img, double w, double h) {
    if (img == null) {
      return ExtendedImage.asset(
        "images/logo.png",
        width: w,
        height: h,
        fit: BoxFit.cover,
        border: Border.all(color: Colors.transparent, width: 0.0),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      );
    } else {
      return ExtendedImage.network(
        img,
        width: w,
        height: h,
        fit: BoxFit.cover,
        cache: true,
        border: Border.all(color: Colors.transparent, width: 0.0),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      );
    }
  }
}
