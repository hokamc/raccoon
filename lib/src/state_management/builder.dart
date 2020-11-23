part of 'rstate.dart';

class _RStateBuilder<T> extends StatefulWidget {
  final RState<T> state;
  final Widget Function(T value) builder;

  const _RStateBuilder({Key key, this.state, this.builder}) : super(key: key);

  @override
  State<_RStateBuilder<T>> createState() => __RStateBuilderState<T>();
}

class __RStateBuilderState<T> extends State<_RStateBuilder<T>> {
  T _cache;
  StreamSubscription _subscription;

  @override
  void initState() {
    _cache = widget.state.state;
    _subscription = widget.state.stream.listen((value) {
      setState(() {
        _cache = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_cache);
  }
}
