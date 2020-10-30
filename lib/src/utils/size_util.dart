import 'package:flutter/material.dart';

extension SizeUtil on BuildContext {
  static Size _thresholdSize = const Size(392.7, 737.5);

  static void setThresholdSize(Size thresholdSize) {
    _thresholdSize = thresholdSize;
  }

  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get _textScaleFactor => MediaQuery.of(this).textScaleFactor;

  double get _scaleWidth => screenWidth / _thresholdSize.width;

  /// smaller size for smaller screen
  /// prevent abnormal design from smaller resolution

  double width(double width) {
    if (screenWidth > _thresholdSize.width) {
      return width;
    } else {
      return width * _scaleWidth;
    }
  }

  double height(double height) {
    if (screenHeight > _thresholdSize.height) {
      return height;
    } else {
      return height * screenHeight / _thresholdSize.height;
    }
  }

  double font(double fontSize) {
    print([screenWidth, _thresholdSize.width]);
    if (screenWidth > _thresholdSize.width) {
      return fontSize;
    } else {
      return fontSize * _scaleWidth / _textScaleFactor;
    }
  }
}
