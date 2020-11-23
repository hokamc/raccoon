import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raccoon/raccoon.dart';

class ContextExample extends StatelessWidget {
  FutureOr<int> getInt() async {
    await Future.delayed(Duration(milliseconds: 500));
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Observer(
        didPop: () => print('didPop'),
        didPush: () => print('didPush'),
        didOnline: () => print('didOnline'),
        didOffline: () => print('didOffline'),
        builder: (context) => Builder(
          builder: (context) {
            return ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // NativeBannerAd(),
                // NativeAd(
                //   placementId: "704147720224464_704180743554495",
                //   height: 500,
                // ),
                Text('Hello World?', style: TextStyle(fontSize: 28)),
                FlatButton(
                  onPressed: () {
                    // print(MediaQuery.of(context).size);
                    // NavUtil.push(Container());
                    // NavUtil.push('/qewqeq');
                    // print(SizeUtil.screenHeight);
                    // print(context.font(12));
                    // print(MediaQuery.of(context).size);
                    // AppUtil.toast('Fail to fetch photos' * 5, closeText: 'CLOSE');
                    // AppUtil.dialog();
                    // Scaffold.of(context).showSnackBar(SnackBar(content: Text('asddadsadasdas'), action: SnackBarAction(label: 'close', onPressed: (){},),));
                    // AdUtil.unityVideoAd("video");
                    // print(await PurchaseUtil.products());
                    // print(await PurchaseUtil.subscriptions());
                    // print(await PurchaseUtil.offerings());
                    // NavUtil.push('/p2');
                    // print(getInt());
                    // AppUtil.dialog(BaseDialog());
                    // AppUtil.dialog(builder: (context) => BaseDialog());
                    // AppUtil.showOneDialog();
                    // AppUtil.toast('asdsad');
                    // LOG.event("name");
                    // LOG.debug("test");
                    // print(FirebaseUtil.remoteConfig());
                    // LOG.event('test');
                    // LOG.error('test error');
                    // AppUtil.rateUs();
                    AppUtil.update();
                    // NavUtil.push('/p2');
                  },
                  child: Text(
                    'locale',
                    style: TextStyle(fontSize: context.font(12)),
                    // style: TextStyle(fontSize: 56),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      content: Text('asd'),
    );
  }
}
