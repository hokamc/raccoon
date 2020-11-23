import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';
import 'package:raccoon/src/core/config.dart';

class Observer extends StatefulWidget {
  final void Function() initial;
  final void Function() dispose;
  final void Function() resumed;
  final void Function() inactive;
  final void Function() paused;
  final void Function() detached;
  final void Function() didPop;
  final void Function() didPopNext;
  final void Function() didPush;
  final void Function() didPushNext;
  final void Function() didOffline;
  final void Function() didOnline;
  final Widget Function(BuildContext) builder;

  const Observer({
    Key key,
    this.initial,
    this.dispose,
    this.resumed,
    this.inactive,
    this.paused,
    this.detached,
    this.didPop,
    this.didPopNext,
    this.didPush,
    this.didPushNext,
    this.builder,
    this.didOffline,
    this.didOnline,
  })  : assert(builder != null),
        super(key: key);

  @override
  _ObserverState createState() => _ObserverState();
}

class _ObserverState extends State<Observer> with WidgetsBindingObserver, RouteAware {
  StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none && await NetworkUtil.hasInternet()) {
        widget.didOnline?.call();
      } else {
        widget.didOffline?.call();
      }
    });
    widget.initial?.call();
  }

  @override
  void didChangeDependencies() {
    Config.observer.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.resumed?.call();
        break;
      case AppLifecycleState.inactive:
        widget.inactive?.call();
        break;
      case AppLifecycleState.paused:
        widget.paused?.call();
        break;
      case AppLifecycleState.detached:
        widget.detached?.call();
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void didPop() {
    widget.didPop?.call();
    super.didPop();
  }

  @override
  void didPopNext() {
    widget.didPopNext?.call();
    super.didPopNext();
  }

  @override
  void didPush() {
    widget.didPush?.call();
    super.didPush();
  }

  @override
  void didPushNext() {
    widget.didPushNext?.call();
    super.didPushNext();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    Config.observer.unsubscribe(this);
    connectivitySubscription.cancel();
    widget.dispose?.call();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder.call(context);
  }
}
