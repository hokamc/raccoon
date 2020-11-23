import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:raccoon/raccoon.dart';
import 'package:raccoon/src/component/flat_button_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class Update extends StatelessWidget {
  static const _UPDATE_TITLE = 'update_title';
  static const _UPDATE_BODY = 'update_body';
  static const _UPDATE_BUTTON = 'update_button';

  final String storeUrl;

  const Update({Key key, this.storeUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String title = tr(_UPDATE_TITLE);
    String body = tr(_UPDATE_BODY);
    String button = tr(_UPDATE_BUTTON);
    if (title == _UPDATE_TITLE) {
      title = 'New Version Available';
    }
    if (body == _UPDATE_BODY) {
      body = 'Please update to the latest version now! Include newest features and bug fixes.';
    }
    if (button == _UPDATE_BUTTON) {
      button = 'Update now';
    }

    return BounceInUp(
      child: AlertDialog(
        title: Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: context.font(20))),
        titlePadding: EdgeInsets.all(context.width(28.0)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.zero,
        content: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.width(350)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(left: context.width(32), right: context.width(32), top: context.width(8)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Bounce(
                      child: Image.asset('packages/raccoon/images/update.png', width: context.width(120)),
                      infinite: true,
                      delay: Duration(milliseconds: 500),
                      from: context.width(10),
                    ),
                    SizedBox(height: context.width(24)),
                    Text(
                      body,
                      style: TextStyle(fontSize: context.font(16)),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: context.width(8)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(context.width(16)),
                child: FlatButtonBar(
                  text: button,
                  icon: LineIcons.download,
                  onPressed: () {
                    launch(storeUrl);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
