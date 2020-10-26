import 'package:flutter/widgets.dart';
import 'package:raccoon/src/log/logger.dart';
import 'package:raccoon/src/dependency_injection/disposable.dart';

part 'di.dart';

abstract class Module extends StatefulWidget {
  final _keys = <String>[];

  Future<void> initial();

  Widget build(BuildContext context);

  Widget loading(BuildContext context) {
    return Container();
  }

  void bind<T>(T instance) {
    final key = _bind(instance);
    _keys.add(key);
  }

  @override
  _ModuleState createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    widget.initial().then((_) => setState(() {
          isReady = true;
        }));
  }

  @override
  void dispose() {
    super.dispose();
    widget._keys.forEach((key) {
      _unbind(key);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isReady) {
      return widget.build(context);
    } else {
      return widget.loading(context);
    }
  }
}
