import 'package:flutter/material.dart';
import 'package:raccoon/src/core/config.dart';

extension SizeExtension on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get _textScaleFactor => MediaQuery.of(this).textScaleFactor;

  double get _scaleWidth => screenWidth / Config.thresholdSize.width;

  /// smaller size for smaller screen
  /// prevent abnormal design from smaller resolution
  double width(double width) {
    if (screenWidth > Config.thresholdSize.width) {
      return width;
    } else {
      return width * _scaleWidth;
    }
  }

  double height(double height) {
    if (screenHeight > Config.thresholdSize.height) {
      return height;
    } else {
      return height * screenHeight / Config.thresholdSize.height;
    }
  }

  double font(double fontSize) {
    if (screenWidth > Config.thresholdSize.width) {
      return fontSize;
    } else {
      return fontSize * _scaleWidth / _textScaleFactor;
    }
  }
}
