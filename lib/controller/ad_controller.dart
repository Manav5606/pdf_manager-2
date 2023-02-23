import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_manager/components/strings.dart';

class AdsProvider extends GetxController implements GetxService {
  bool interstitialLoaded = false;
  bool rewardAdLoaded = false;
  int count = 1;

  showAd() {
    if (showAds) {
      if (count.isEven) {
        showInterstitialAd();
      } else {
        showInterstitialAd();
      }
      count++;
    }
    update();
  }

  Future showInterstitialAd() async {
    if (interstitialLoaded) {
      await FacebookInterstitialAd.showInterstitialAd();
      interstitialLoaded = false;
      loadInterstitialAd();
    } else {
      loadInterstitialAd();
      await FacebookInterstitialAd.showInterstitialAd();
      interstitialLoaded = false;
      loadInterstitialAd();
    }

    update();
  }

  ///// InterstitialAd

  void loadInterstitialAd() {
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: interstitialId,
      listener: (result, value) {
        debugPrint(value);
        if (result == InterstitialAdResult.LOADED) {
          interstitialLoaded = true;
        }
        if (result == InterstitialAdResult.DISMISSED &&
            value["invalidated"] == true) {
          interstitialLoaded = false;
        }
      },
    );
    update();
  }

  showRewardAd() async {
    if (rewardAdLoaded) {
      await FacebookRewardedVideoAd.showRewardedVideoAd();
      rewardAdLoaded = false;
      loadRewardAd();
    } else {
      loadRewardAd();
      await FacebookRewardedVideoAd.showRewardedVideoAd();
      rewardAdLoaded = false;
      loadRewardAd();
    }

    update();
  }

  ///// Reward Ad

  void loadRewardAd() {
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: rewardAdId,
      listener: (result, value) {
        debugPrint(value);
        if (result == RewardedVideoAdResult.LOADED) {
          rewardAdLoaded = true;
        }
        if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
            value["invalidated"] == true) {
          rewardAdLoaded = false;
        }
      },
    );
    update();
  }

  static Widget adWidget() {
    if (!showAds) {
      return const SizedBox.shrink();
    } else {
      return FacebookBannerAd(
        placementId: bannerId,
        bannerSize: BannerSize.STANDARD,
        listener: (result, value) {
          switch (result) {
            case BannerAdResult.ERROR:
              debugPrint("Error: $value");
              break;
            case BannerAdResult.LOADED:
              debugPrint("Loaded: $value");
              break;
            case BannerAdResult.CLICKED:
              debugPrint("Clicked: $value");
              break;
            case BannerAdResult.LOGGING_IMPRESSION:
              debugPrint("Logging Impression: $value");
              break;
          }
        },
      );
    }
  }

  static AdsProvider get instance => Get.put(AdsProvider());
}
