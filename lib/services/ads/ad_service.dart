import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class AdService {
  Future<void> initialize();
  Future<BannerAd?> loadBannerAd();
  Future<InterstitialAd?> loadInterstitialAd();
}
