import 'package:example/catcher_example.dart';
import 'package:example/firebase_example.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

void main() {
  // runApp(MyApp());

  Raccoon(RaccoonApp(
    // home: StateExample(),
    // home: CatcherExample(),
    home: FirebaseExample(),
  ));
}
