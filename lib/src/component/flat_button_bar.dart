import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class FlatButtonBar extends StatelessWidget {
  final double width;
  final Color color;
  final Color textColor;
  final void Function() onPressed;
  final IconData icon;
  final String text;

  const FlatButtonBar({Key key, this.width, this.color, this.textColor, this.onPressed, this.icon, this.text})
      : assert(text != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[];
    if (icon != null) {
      children.add(
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(left: context.width(8)),
            child: Icon(icon, size: context.width(24)),
          ),
        ),
      );
    }
    children.add(Align(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(fontSize: context.font(14), fontWeight: FontWeight.bold),
      ),
    ));

    return FlatButton(
      minWidth: width ?? context.screenWidth,
      color: color ?? context.dark ? context.accentColor : context.primaryColor,
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        height: context.width(48),
        child: Stack(
          children: children,
        ),
      ),
      onPressed: () {
        onPressed?.call();
      },
    );
  }
}
