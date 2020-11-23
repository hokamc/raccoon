import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:raccoon/src/core/config.dart';
import 'package:raccoon/src/core/raccoon_module.dart';

class Raccoon {
  final Color loadingColor;
  final Size designSize;
  final bool portraitOnly;
  final bool landscapeOnly;
  final String storeUrl;

  /// child should contain raccoon app
  final Widget app;

  /// localization
  final String translationsPath;
  final List<Locale> supportedLocales;

  Raccoon(
    this.app, {
    this.loadingColor,
    this.designSize,
    this.storeUrl,
    this.portraitOnly = false,
    this.landscapeOnly = false,
    this.translationsPath = 'assets/translations',
    this.supportedLocales = const [Locale('en', 'US')],
  }) {
    _initial();
  }

  void _initial() async {
    if (designSize != null) {
      Config.thresholdSize = designSize;
    }
    if (loadingColor != null) {
      Config.loadingColor = loadingColor;
    }
    if (storeUrl != null) {
      Config.storeUrl = storeUrl;
    }

    WidgetsFlutterBinding.ensureInitialized();

    List<DeviceOrientation> orientations = [];
    if (portraitOnly) orientations.addAll([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    if (landscapeOnly) orientations.addAll([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    if (orientations.isNotEmpty) SystemChrome.setPreferredOrientations(orientations);

    await Firebase.initializeApp();

    _setCrashlytics(main: () async {
      runApp(RaccoonModule(
        child: EasyLocalization(
          path: translationsPath,
          supportedLocales: supportedLocales,
          preloaderColor: Config.loadingColor,
          child: app,
        ),
      ));
    });
  }

  void _setCrashlytics({@required Future<void> Function() main}) {
    FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    runZonedGuarded<Future<void>>(main, FirebaseCrashlytics.instance.recordError);

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
      );
    }).sendPort);

    _setCustomCrashParams();
  }

  void _setCustomCrashParams() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      FirebaseCrashlytics.instance.setCustomKey("id", androidDeviceInfo.id);
      FirebaseCrashlytics.instance.setCustomKey("androidId", androidDeviceInfo.androidId);
      FirebaseCrashlytics.instance.setCustomKey("board", androidDeviceInfo.board);
      FirebaseCrashlytics.instance.setCustomKey("bootloader", androidDeviceInfo.bootloader);
      FirebaseCrashlytics.instance.setCustomKey("brand", androidDeviceInfo.brand);
      FirebaseCrashlytics.instance.setCustomKey("device", androidDeviceInfo.device);
      FirebaseCrashlytics.instance.setCustomKey("display", androidDeviceInfo.display);
      FirebaseCrashlytics.instance.setCustomKey("fingerprint", androidDeviceInfo.fingerprint);
      FirebaseCrashlytics.instance.setCustomKey("hardware", androidDeviceInfo.hardware);
      FirebaseCrashlytics.instance.setCustomKey("host", androidDeviceInfo.host);
      FirebaseCrashlytics.instance.setCustomKey("isPhysicalDevice", androidDeviceInfo.isPhysicalDevice);
      FirebaseCrashlytics.instance.setCustomKey("manufacturer", androidDeviceInfo.manufacturer);
      FirebaseCrashlytics.instance.setCustomKey("model", androidDeviceInfo.model);
      FirebaseCrashlytics.instance.setCustomKey("product", androidDeviceInfo.product);
      FirebaseCrashlytics.instance.setCustomKey("tags", androidDeviceInfo.tags);
      FirebaseCrashlytics.instance.setCustomKey("type", androidDeviceInfo.type);
      FirebaseCrashlytics.instance.setCustomKey("versionBaseOs", androidDeviceInfo.version.baseOS);
      FirebaseCrashlytics.instance.setCustomKey("versionCodename", androidDeviceInfo.version.codename);
      FirebaseCrashlytics.instance.setCustomKey("versionIncremental", androidDeviceInfo.version.incremental);
      FirebaseCrashlytics.instance.setCustomKey("versionPreviewSdk", androidDeviceInfo.version.previewSdkInt);
      FirebaseCrashlytics.instance.setCustomKey("versionRelease", androidDeviceInfo.version.release);
      FirebaseCrashlytics.instance.setCustomKey("versionSdk", androidDeviceInfo.version.sdkInt);
      FirebaseCrashlytics.instance.setCustomKey("versionSecurityPatch", androidDeviceInfo.version.securityPatch);
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      FirebaseCrashlytics.instance.setCustomKey("model", iosInfo.model);
      FirebaseCrashlytics.instance.setCustomKey("isPhysicalDevice", iosInfo.isPhysicalDevice);
      FirebaseCrashlytics.instance.setCustomKey("name", iosInfo.name);
      FirebaseCrashlytics.instance.setCustomKey("identifierForVendor", iosInfo.identifierForVendor);
      FirebaseCrashlytics.instance.setCustomKey("localizedModel", iosInfo.localizedModel);
      FirebaseCrashlytics.instance.setCustomKey("systemName", iosInfo.systemName);
      FirebaseCrashlytics.instance.setCustomKey("utsnameVersion", iosInfo.utsname.version);
      FirebaseCrashlytics.instance.setCustomKey("utsnameRelease", iosInfo.utsname.release);
      FirebaseCrashlytics.instance.setCustomKey("utsnameMachine", iosInfo.utsname.machine);
      FirebaseCrashlytics.instance.setCustomKey("utsnameNodename", iosInfo.utsname.nodename);
      FirebaseCrashlytics.instance.setCustomKey("utsnameSysname", iosInfo.utsname.sysname);
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    FirebaseCrashlytics.instance.setCustomKey("version", packageInfo.version);
    FirebaseCrashlytics.instance.setCustomKey("appName", packageInfo.appName);
    FirebaseCrashlytics.instance.setCustomKey("buildNumber", packageInfo.buildNumber);
    FirebaseCrashlytics.instance.setCustomKey("packageName", packageInfo.packageName);
  }
}
