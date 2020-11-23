import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RaccoonModule extends Module {
  final Widget child;

  RaccoonModule({@required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  Future<void> initialize() async {
    bind(await SharedPreferences.getInstance());
  }
}
