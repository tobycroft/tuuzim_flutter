import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:ok_image/ok_image.dart';
import 'package:tuuzim_flutter/config/config.dart';
import 'package:yin_drag_sacle/core/drag_scale_widget.dart';

class CacheImage {
  static network(dynamic img, double w, double h) {
    if (img == null||img.toString().length<10) {
      return DefaultImage(w, h);
    } else {
      return new OKImage(
        url: img.toString(),
        width: w,
        height: h,
        loadingWidget: DefaultImage(w, h),
        timeout: Duration(seconds: 5),
        fit: BoxFit.cover,
      );
    }
  }

  static network_fit(dynamic img, double w, double h, BoxFit boxFit) {
    if (img == null) {
      return DefaultImage(w, h);
    } else {
      return new OKImage(
        url: img.toString(),
        width: w,
        height: h,
        loadingWidget: DefaultImage(w, h),
        timeout: Duration(seconds: 5),
        fit: (boxFit == null ? BoxFit.cover : BoxFit.fitWidth),
      );
    }
  }

  static fullscreen(dynamic img, double w, double h) {
    return FullScreenWidget(
      child: Hero(
        tag: img,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: pinch(img, w, h),
        ),
      ),
    );
  }

  static pinch(dynamic img, double w, double h) {
    return DragScaleContainer(
      child: network_fit(img, w, h, BoxFit.fitWidth),
      doubleTapStillScale: false,
      maxScale: 4, //
    );
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
