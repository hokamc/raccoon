import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavUtil {
  NavUtil._();

  static GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();

  static push(String name, [Object argument]) {
    key.currentState.pushNamed(name, arguments: argument);
  }

  static pop() {
    key.currentState.pop();
  }
}
