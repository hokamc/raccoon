import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';

class RaccoonApp extends StatelessWidget {
  final Widget home;

  const RaccoonApp({Key key, @required this.home})
      : assert(home != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics())],
      home: home,
    );
  }
}
