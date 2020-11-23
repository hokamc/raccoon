import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:raccoon/src/extensions/theme_extension.dart';
import 'package:raccoon/src/log/logger.dart';

class NativeAd extends StatelessWidget {
  final Color backgroundColor;
  final Color textColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final String placementId;
  final double height;

  const NativeAd({
    Key key,
    this.backgroundColor,
    this.textColor,
    this.buttonColor,
    this.buttonTextColor,
    this.placementId = "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
    this.height = 250,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _bgColor = backgroundColor ?? context.cardColor;
    final Color _textColor = textColor ?? context.textColor;
    final Color _buttonColor = buttonColor ?? context.primaryColor;
    final Color _buttonTextColor = buttonTextColor ?? Colors.white;

    return FacebookNativeAd(
      placementId: placementId,
      adType: NativeAdType.NATIVE_AD,
      width: double.infinity,
      height: height,
      backgroundColor: _bgColor,
      titleColor: _textColor,
      descriptionColor: _textColor,
      buttonColor: _buttonColor,
      buttonTitleColor: _buttonTextColor,
      buttonBorderColor: _buttonTextColor,
      labelColor: _buttonTextColor,
      keepAlive: true,
      keepExpandedWhileLoading: false,
      expandAnimationDuraion: 300,
      listener: (result, value) {
        if (result == NativeAdResult.CLICKED) {
          LOG.event("banner_clicked", {"count": 1});
        } else if (result == NativeAdResult.LOGGING_IMPRESSION) {
          LOG.event("banner_impressing");
        } else if (result == NativeAdResult.ERROR) {
          LOG.event("banner_error", {"count": 1});
        }
      },
    );
  }
}
