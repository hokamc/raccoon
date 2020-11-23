import 'package:easy_localization/easy_localization.dart' as localization;
import 'package:flutter/material.dart';
import 'package:raccoon/src/core/config.dart';

/// translate
String tr(String key, {List<String> args}) {
  return localization.tr(key, args: args);
}

class LocaleUtil {
  LocaleUtil._();

  static Locale locale() {
    return Config.key.currentContext.locale;
  }

  static changeLocale(Locale locale) {
    Config.key.currentContext.locale = locale;
  }

  static deleteLocale() {
    Config.key.currentContext.deleteSaveLocale();
  }
}
