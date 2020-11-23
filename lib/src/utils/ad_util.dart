import 'package:adsunity/adsunity.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:raccoon/src/ad/unity_listener.dart';

class AdUtil {
  AdUtil._();

  static void initFB() {
    FacebookAudienceNetwork.init();
  }

  static void initUnity({String unityAndroidId, String unityIOSId}) {
    UnityAds.initialize(unityAndroidId ?? '3270261', unityIOSId ?? '3270260', UnityListener(), testMode: unityAndroidId == null);
  }

  static void unityVideoAd(String placementId) {
    UnityAds.show(placementId);
  }
}
