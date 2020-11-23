import 'package:raccoon/src/core/config.dart';

class NavUtil {
  NavUtil._();

  static void push(String name, {Object argument, Function() onBack}) {
    Config.key.currentState.pushNamed(name, arguments: argument).then((value) => onBack?.call());
  }

  static void pop<T>(T value) {
    Config.key.currentState.pop(value);
  }
}
