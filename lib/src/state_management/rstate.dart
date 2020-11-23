import 'dart:async';

import 'package:flutter/material.dart';

part 'builder.dart';

class RState<T> {
  T _cache;
  StreamController<T> _streamController;

  T get state => _cache;

  Stream<T> get stream => _streamController.stream;

  RState([T initialData]) {
    _cache = initialData;
    _streamController = StreamController.broadcast();
    _streamController.add(initialData);
  }

  void push(T newValue) {
    _cache = newValue;
    _streamController.add(newValue);
  }

  void dispose() {
    _streamController.close();
  }

  Widget build(Widget Function(T) builder) {
    return _RStateBuilder(
      state: this,
      builder: builder,
    );
  }
}
