import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class FirebaseExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FlatButton(
              onPressed: () async {
                LOG.debug((await FirebaseUtil.remoteConfig()));
                LOG.event('testing');
                Navigator.push(context, MaterialPageRoute(builder: (context) => Container(), settings: RouteSettings(name: 'testing')));
              },
              child: Text('remote config')),
        ],
      ),
    );
  }
}
