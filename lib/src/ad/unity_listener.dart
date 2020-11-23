import 'package:adsunity/adsunity.dart';
import 'package:raccoon/raccoon.dart';

class UnityListener with UnityAdsListener {
  @override
  void onUnityAdsError(UnityAdsError error, String message) {
    LOG.error('$message $error');
  }

  @override
  void onUnityAdsFinish(String placementId, FinishState result) {
    LOG.event("video_ad_finished", {"count": 1});
  }

  @override
  void onUnityAdsReady(placementId) {}

  @override
  void onUnityAdsStart(placementId) {}
}
