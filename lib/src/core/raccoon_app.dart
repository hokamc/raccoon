import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/src/core/config.dart';
import 'package:raccoon/src/nav/route.dart';
import 'package:raccoon/src/nav/unknown_page.dart';

class RaccoonApp extends StatelessWidget {
  /// navigation
  final String initialRoute;
  final RaccoonRoute unknownRoute;
  final Map<String, RaccoonRoute> routes = {};

  /// theme
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  /// config
  final bool isDevicePreviewOn;

  RaccoonApp({
    Key key,
    @required List<RaccoonRoute> routes,
    this.unknownRoute,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.initialRoute = '/',
    this.isDevicePreviewOn = false,
  }) : super(key: key) {
    routes.forEach((route) {
      if (this.routes.containsKey(route.name)) {
        throw new ArgumentError("duplicated route names");
      } else {
        this.routes[route.name] = route;
      }
    });
  }

  MaterialApp app(BuildContext context, {List<Widget Function(BuildContext, Widget)> builders, Locale locale}) {
    return MaterialApp(
      theme: theme ?? ThemeData(fontFamily: 'packages/raccoon/Ubuntu'),
      darkTheme: theme ?? ThemeData(fontFamily: 'packages/raccoon/Ubuntu', brightness: Brightness.dark, accentColor: Colors.orange),
      themeMode: themeMode,
      navigatorKey: Config.key,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
        Config.observer,
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
      builder: (context, widget) {
        Widget child = widget;
        builders.forEach((builder) {
          child = builder.call(context, child);
        });
        return child;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isDevicePreviewOn) {
      return DevicePreview(
        builder: (context) {
          return app(
            context,
            builders: [
              DevicePreview.appBuilder,
            ],
            locale: DevicePreview.locale(context),
          );
        },
      );
    } else {
      return Builder(
        builder: (context) {
          return app(
            context,
            builders: [],
          );
        },
      );
    }
  }
}
