import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_service.dart';
import 'ad_helper.dart';

class AdMobService implements AdService {
  @override
  Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  @override
  Future<BannerAd?> loadBannerAd() async {
    final BannerAd bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    );

    try {
      await bannerAd.load();
      return bannerAd;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<InterstitialAd?> loadInterstitialAd() async {
    try {
      final completer = Completer<InterstitialAd?>();

      await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => completer.complete(ad),
          onAdFailedToLoad: (error) => completer.complete(null),
        ),
      );

      return await completer.future;
    } catch (e) {
      return null;
    }
  }
}
