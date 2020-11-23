import 'package:flutter/widgets.dart';

class RaccoonRoute {
  final String name;
  final Widget Function(RouteSettings setting, BuildContext context) builder;

  RaccoonRoute({@required this.name, @required this.builder});
}