import 'dart:ui';

import 'package:flutter/material.dart';

class Config {
  Config._();

  static Size thresholdSize = const Size(392.7, 737.5);
  static Color loadingColor = Colors.black;
  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
  static RouteObserver observer = RouteObserver();
  static String storeUrl = 'https://github.com/hokamc/raccoon';
  static OverlayEntry toastEntry;

  static String raccoonKey(String name) {
    return '#raccoon#' + name;
  }
}
