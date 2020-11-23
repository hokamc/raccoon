import 'package:flutter/material.dart';
import 'package:raccoon/src/extensions/size_extension.dart';

class UnknownPage extends StatelessWidget {
  final String route;

  const UnknownPage({Key key, this.route}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('UNKNOWN ROUTE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.font(32), color: Colors.red)),
            Text(route, style: TextStyle(fontWeight: FontWeight.bold, fontSize: context.font(18))),
          ],
        ),
      ),
    );
  }
}
