import 'dart:async';

class Data<T> {
  T _cache;
  StreamController<T> _streamController;

  T get cache => _cache;
  Stream<T> get stream => _streamController.stream;

  Data([T initialData]) {
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
}
