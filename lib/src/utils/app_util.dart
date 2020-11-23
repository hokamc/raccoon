import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:raccoon/raccoon.dart';
import 'package:raccoon/src/component/give_us_feedback.dart';
import 'package:raccoon/src/component/toast.dart';
import 'package:raccoon/src/component/update.dart';
import 'package:raccoon/src/core/config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUtil {
  AppUtil._();

  /// pattern 1.0.0
  /// localization: update_title, update_body, update_button
  static void update({String storeUrl, bool force = true, Future<bool> Function(String) verifyVersion}) async {
    String inAppVersion = (await PackageInfo.fromPlatform()).version;
    bool needUpdate = false;
    if (verifyVersion != null) {
      needUpdate = await verifyVersion(inAppVersion);
    } else {
      Map<String, String> config = await FirebaseUtil.remoteConfig({'version': inAppVersion});
      needUpdate = config['version'] != inAppVersion;
    }

    if (needUpdate) {
      dialog(
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => !force,
            child: Update(
              storeUrl: storeUrl ?? Config.storeUrl,
            ),
          );
        },
        barrierDismissible: !force,
      );
      LOG.debug('update, version=$inAppVersion');
      LOG.event('update', {'version': inAppVersion});
    }
  }

  /// ask again until rating is higher than three
  /// localization: rate_title, rate_body, rate_button
  static void rateUs({String customKey, String storeUrl, int hoursToAskAgain = 120}) async {
    SharedPreferences sharedPreferences = inject();
    String key = customKey ?? Config.raccoonKey('rate#us');
    String config = sharedPreferences.get(key);
    int stars = 0;
    DateTime last = DateTime.now();
    if (config == null) {
      sharedPreferences.setString(key, "$stars#${last.toIso8601String()}");
    } else {
      List<String> keys = config.split("#");
      stars = int.parse(keys[0]);
      last = DateTime.parse(keys[1]);
    }
    DateTime currentTime = DateTime.now();
    if (stars < 4 && currentTime.difference(last).inHours > hoursToAskAgain) {
      int result = await dialog(builder: (context) => GiveUsFeedBack()) ?? 0;
      sharedPreferences.setString(key, "$result#${currentTime.toIso8601String()}");
      if (result > 3) {
        launch(storeUrl ?? Config.storeUrl);
      }
      LOG.debug('rate, stars=$result, time=$last');
      LOG.event('rate', {'stars': result});
    }
  }

  static Future<T> dialog<T>({
    WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = Colors.black26,
  }) {
    BuildContext context = Config.key.currentContext;
    return showDialog(
      context: context,
      barrierColor: Colors.black26,
      barrierDismissible: barrierDismissible,
      builder: builder,
    );
  }

  static void toast(String text, {int millisecondToCancel = 2000}) {
    if (Config.toastEntry != null) {
      Config.toastEntry.remove();
    }
    OverlayEntry overlayEntry = new OverlayEntry(builder: (context) {
      return Toast(text, millisecondToCancel: millisecondToCancel);
    });
    Config.key.currentState.overlay.insert(overlayEntry);
    Config.toastEntry = overlayEntry;
    Future.delayed(Duration(milliseconds: millisecondToCancel)).then((value) {
      if (Config.toastEntry == overlayEntry) {
        Config.toastEntry.remove();
        Config.toastEntry = null;
      }
    });
  }
}
