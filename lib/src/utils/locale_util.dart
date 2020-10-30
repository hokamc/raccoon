import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

/// translate
String tr(String key, {List<String> args}) {
  return localization.tr(key, args: args);
}

class LocaleUtil {
  LocaleUtil._();

  static Locale locale() {
    return NavUtil.key.currentContext.locale;
  }

  static changeLocale(Locale locale) {
    NavUtil.key.currentContext.locale = locale;
  }

  static deleteLocale() {
    NavUtil.key.currentContext.deleteSaveLocale();
  }
}
