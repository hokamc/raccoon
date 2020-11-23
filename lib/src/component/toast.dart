import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class Toast extends StatefulWidget {
  final String text;
  final int millisecondToCancel;
  final Color textColor;
  final Color backgroundColor;
  final Widget Function(String) builder;

  const Toast(
    this.text, {
    Key key,
    this.builder,
    this.millisecondToCancel = 2000,
    this.textColor = Colors.white,
    this.backgroundColor = Colors.black26,
  }) : super(key: key);

  @override
  _ToastState createState() => _ToastState();
}

class _ToastState extends State<Toast> with SingleTickerProviderStateMixin {
  bool pop;
  int animationDuration;

  @override
  void initState() {
    pop = false;
    animationDuration = 300;
    Future.delayed(Duration(milliseconds: widget.millisecondToCancel - animationDuration)).then((_) {
      setState(() {
        pop = true;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: context.screenWidth,
      child: Material(
        color: Colors.transparent,
        child: widget.builder == null
            ? Container(
                margin: EdgeInsets.all(context.width(16)),
                padding: EdgeInsets.all(context.width(14)),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: context.font(15),
                    color: widget.textColor,
                  ),
                ),
              )
            : widget.builder.call(widget.text),
      ),
    );

    Widget animate = pop
        ? FadeOutLeftBig(child: child, animate: true, duration: Duration(milliseconds: animationDuration))
        : BounceInRight(child: child, animate: true, duration: Duration(milliseconds: animationDuration));

    return Positioned(bottom: context.width(16), child: animate);
  }
}
