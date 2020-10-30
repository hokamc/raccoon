import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/src/nav/route.dart';
import 'package:raccoon/src/utils/nav_util.dart';
import 'package:raccoon/src/utils/size_util.dart';

class RaccoonApp extends StatelessWidget {
  /// localization
  final String translationsPath;
  final List<Locale> supportedLocales;
  final Color loadingColor;

  /// navigation
  final String initialRoute;
  final RaccoonRoute unknownRoute;
  final Map<String, RaccoonRoute> routes = {};

  /// config
  final bool isDevicePreviewOn;

  RaccoonApp({
    Key key,
    @required List<RaccoonRoute> routes,
    this.translationsPath = 'assets/translations',
    this.supportedLocales = const [Locale('en', 'US')],
    this.initialRoute = '/',
    this.isDevicePreviewOn = false,
    this.loadingColor = Colors.black,
    this.unknownRoute,
  }) : super(key: key) {
    routes.forEach((route) {
      if (this.routes.containsKey(route.name)) {
        throw new ArgumentError("duplicated route names");
      } else {
        this.routes[route.name] = route;
      }
    });
  }

  MaterialApp app(BuildContext context, {Widget Function(BuildContext, Widget) builder, Locale locale}) {
    return MaterialApp(
      navigatorKey: NavUtil.key,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: locale ?? context.locale,
      initialRoute: initialRoute,
      onGenerateRoute: (setting) {
        RaccoonRoute route = routes[setting.name];
        if (route != null) {
          return MaterialPageRoute(
            settings: setting,
            builder: (context) {
              return route.builder(setting, context);
            },
          );
        }
        return null;
      },
      onUnknownRoute: (setting) {
        return MaterialPageRoute(
          settings: setting,
          builder: (context) {
            if (unknownRoute != null) {
              return unknownRoute.builder(setting, context);
            } else {
              return UnknownPage(route: setting.name);
            }
          },
        );
      },
      builder: builder,
    );
  }

  Widget child() {
    if (isDevicePreviewOn) {
      return DevicePreview(
        builder: (context) {
          return app(
            context,
            builder: DevicePreview.appBuilder,
            locale: DevicePreview.of(context).locale,
          );
        },
      );
    } else {
      return Builder(
        builder: (context) {
          return app(context);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      path: translationsPath,
      supportedLocales: supportedLocales,
      preloaderColor: loadingColor,
      child: child(),
    );
  }
}

class UnknownPage extends StatelessWidget {
  final String route;

  const UnknownPage({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UNKNOWN ROUTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.font(32), color: Colors.red)),
            Text(route, style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.font(18))),
          ],
        ),
      ),
    );
  }
}
