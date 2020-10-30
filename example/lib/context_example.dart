import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class ContextExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
            onPressed: () {
              // print(MediaQuery.of(context).size);
              // NavUtil.push(Container());
              NavUtil.push('/qewqeq');
              // print(SizeUtil.screenHeight);
              print(context.font(12));
              print(MediaQuery.of(context).size);
            },
            child: Text(
              'locale',
              style: TextStyle(fontSize: context.font(12)),
              // style: TextStyle(fontSize: 56),
            ),
          ),
        ],
      ),
    );
  }
}
