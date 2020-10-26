import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:device_info/device_info.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:package_info/package_info.dart';
import 'package:raccoon/raccoon.dart';

class Raccoon {
  final RaccoonApp app;

  Raccoon(this.app) {
    _initial();
  }

  void _initial() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp();

    FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

    _setCrashlytics(main: () async {
      runApp(app);
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
