import 'dart:async';

import 'package:flutter/widgets.dart';
import 'data.dart';

class DataBuilder<T> extends StatefulWidget {
  final Data<T> data;
  final T initialData;
  final Stream<T> stream;
  final Widget Function(BuildContext, T value) builder;
  const DataBuilder({Key key, this.data, this.initialData, this.stream, @required this.builder})
      : assert(data != null && initialData == null && stream == null || data == null && initialData != null && stream != null),
        super(key: key);
  @override
  State<DataBuilder<T>> createState() => _DataBuilderState<T>();
}

class _DataBuilderState<T> extends State<DataBuilder<T>> {
  T _cache;
  StreamSubscription _subscription;

  @override
  void initState() {
    if (widget.data != null) {
      _cache = widget.data.cache;
      _subscription = widget.data.stream.listen((value) {
        setState(() {
          _cache = value;
        });
      });
    } else {
      _cache = widget.initialData;
      _subscription = widget.stream.listen((value) {
        setState(() {
          _cache = value;
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _cache);
  }
}
