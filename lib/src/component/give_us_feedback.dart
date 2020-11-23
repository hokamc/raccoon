import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:raccoon/raccoon.dart';
import 'package:raccoon/src/animation/bubble_pop.dart';
import 'package:raccoon/src/component/flat_button_bar.dart';

class GiveUsFeedBack extends StatefulWidget {
  @override
  _GiveUsFeedBackState createState() => _GiveUsFeedBackState();
}

class _GiveUsFeedBackState extends State<GiveUsFeedBack> {
  static const _UPDATE_TITLE = 'rate_title';
  static const _UPDATE_BODY = 'rate_body';
  static const _UPDATE_BUTTON = 'rate_button';

  int stars;

  void changeStars(int i) {
    setState(() {
      stars = i;
    });
  }

  @override
  void initState() {
    stars = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String title = tr(_UPDATE_TITLE);
    String body = tr(_UPDATE_BODY);
    String button = tr(_UPDATE_BUTTON);
    if (title == _UPDATE_TITLE) {
      title = 'Give Us Feedback';
    }
    if (body == _UPDATE_BODY) {
      body = 'If you like our app, please give us a big FIVE stars! Thank you!';
    }
    if (button == _UPDATE_BUTTON) {
      button = 'Submit';
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
                      child: Image.asset('packages/raccoon/images/like.png', width: context.width(120)),
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
                    SizedBox(height: context.width(24)),
                    _StarsBar(
                      onChange: changeStars,
                    ),
                    SizedBox(height: context.width(8)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(context.width(16)),
                child: FlatButtonBar(
                  text: button,
                  icon: LineIcons.thumbs_o_up,
                  onPressed: () {
                    NavUtil.pop(stars);
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

class _StarsBar extends StatefulWidget {
  final void Function(int) onChange;

  const _StarsBar({Key key, this.onChange}) : super(key: key);

  @override
  __StarsBarState createState() => __StarsBarState();
}

class __StarsBarState extends State<_StarsBar> {
  List<bool> stars = [false, false, false, false, false];
  List<GlobalKey<BubblePopState>> keys = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000)).then((_) {
      for (var key in keys) {
        key.currentState.animate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = context.width(36);

    List<Widget> starWidgets = [];
    for (int i = 0; i < stars.length; i++) {
      starWidgets.add(BubblePop(
        key: keys[i],
        duration: Duration(milliseconds: 300 + 300 * i),
        child: GestureDetector(
          onTap: () {
            setState(() {
              for (int j = 0; j <= i; j++) {
                stars[j] = true;
                keys[j].currentState.animate();
              }
              for (int j = i + 1; j < stars.length; j++) {
                stars[j] = false;
              }
            });
            widget.onChange(i + 1);
          },
          child: Icon(
            stars[i] ? LineIcons.star : LineIcons.star_o,
            size: size,
            color: Colors.yellow.shade600,
          ),
        ),
        size: size,
      ));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: starWidgets,
    );
  }
}
