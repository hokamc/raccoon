import 'package:example/context_example.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

void main() {
  // runApp(MyApp());

  Raccoon(
    AppModule(
      RaccoonApp(
        // home: StateExample(),
        // home: CatcherExample(),
        // home: FirebaseExample(),
        isDevicePreviewOn: true,
        // theme: ThemeData(primarySwatch: Colors.green, fontFamily: 'packages/raccoon/Montserrat'),
        // themeMode: ThemeMode.dark,
        routes: [
          RaccoonRoute(name: '/', builder: (setting, context) => ContextExample()),
          RaccoonRoute(name: '/p2', builder: (setting, context) => ContextExample()),
        ],
      ),
    ),
  );
}

class AppModule extends Module {
  final Widget app;

  AppModule(this.app);

  @override
  Widget build(BuildContext context) {
    return app;
  }

  @override
  Future<void> initialize() async {
    // AdUtil.initUnity();
    // PurchaseUtil.init();
    bind(await test());
  }

  @override
  void resumed() {
    print('resumed');
  }

  @override
  void paused() {
    print('paused');
  }

  @override
  void inactive() {
    print('inactive');
  }

  Future<int> test() async {
    await Future.delayed(Duration(milliseconds: 300));
    return 1;
  }
}
