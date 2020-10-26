import 'dart:async';

import 'package:flutter/material.dart';
import 'data.dart';

class MultiDataBuilder<T> extends StatefulWidget {
  final List<Data<dynamic>> datas;
  final List<dynamic> initialDatas;
  final List<Stream<dynamic>> streams;
  final T Function(List<dynamic> values) converter;
  final Widget Function(BuildContext context, T value) builder;

  const MultiDataBuilder({Key key, this.initialDatas, this.streams, this.datas, @required this.converter, @required this.builder})
      : assert(datas != null && initialDatas == null && streams == null || datas == null && initialDatas != null && streams != null && initialDatas.length == streams.length),
        super(key: key);

  @override
  State<MultiDataBuilder<T>> createState() => _MultiDataBuilderState<T>();
}

class _MultiDataBuilderState<T> extends State<MultiDataBuilder<T>> {
  List<dynamic> _cache;
  List<StreamSubscription> _subscriptions;

  @override
  void initState() {
    _subscriptions = [];
    List<Stream> streams;
    if (widget.datas != null) {
      _cache = widget.datas.map((e) => e.cache).toList();
      streams = widget.datas.map((e) => e.stream).toList();
    } else {
      _cache = List.of(widget.initialDatas);
      streams = widget.streams;
    }

    for (var i = 0; i < streams.length; i++) {
      var stream = streams[i];
      _subscriptions.add(stream.listen((value) {
        setState(() {
          _cache[i] = value;
        });
      }));
    }
    super.initState();
  }

  @override
  void dispose() {
    _subscriptions.forEach((subscription) {
      subscription.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.converter(_cache));
  }
}
