part of 'module.dart';

final Map<String, dynamic> _beanContext = {};

T inject<T>() {
  final key = '${T.toString()}';
  final result = _beanContext[key];
  if (result == null) throw ArgumentError('bean not found, key=$key');
  return result as T;
}

String _bind<T>(T instance) {
  final key = '${instance.runtimeType.toString()}';
  final result = _beanContext.putIfAbsent(key, () => instance);
  if (result != instance) {
    throw ArgumentError('duplicated bindings, key=$key');
  }

  LOG.info('bind $key');
  return key;
}

void _unbind<T>(String key) {
  final result = _beanContext.remove(key);
  if (result == null) {
    throw ArgumentError('bean not found, key=$key');
  }
  if (result is Disposable) {
    result.dispose();
  }

  LOG.info('unbind $key');
}