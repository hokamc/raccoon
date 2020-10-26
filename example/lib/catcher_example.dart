import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raccoon/raccoon.dart';

class CatcherExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            for (var i = 0; i < 100; i++) {
              LOG.debug("test$i");
            }
            LOG.error('asdasd');
            throw new MissingPluginException();
          },
          child: Text('throws'),
        ),
      ),
    );
  }
}
