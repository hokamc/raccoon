import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  Color get primaryColor => Theme.of(this).primaryColor;

  Color get accentColor => Theme.of(this).accentColor;

  Color get backgroundColor => Theme.of(this).backgroundColor;

  Color get cardColor => Theme.of(this).cardColor;

  Color get textColor => Theme.of(this).textTheme.bodyText1.color;

  String get fontFamily => Theme.of(this).textTheme.bodyText1.fontFamily;

  bool get dark => Theme.of(this).brightness == Brightness.dark;
}
