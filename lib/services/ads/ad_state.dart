import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ad_state.g.dart';

@immutable
class AdState {
  final BannerAd? bannerAd;
  final bool isBannerAdReady;
  final bool isInterstitialAdReady;

  const AdState({
    this.bannerAd,
    this.isBannerAdReady = false,
    this.isInterstitialAdReady = false,
  });

  AdState copyWith({
    BannerAd? bannerAd,
    bool? isBannerAdReady,
    bool? isInterstitialAdReady,
  }) {
    return AdState(
      bannerAd: bannerAd ?? this.bannerAd,
      isBannerAdReady: isBannerAdReady ?? this.isBannerAdReady,
      isInterstitialAdReady:
          isInterstitialAdReady ?? this.isInterstitialAdReady,
    );
  }
}

@riverpod
class AdNotifier extends _$AdNotifier {
  InterstitialAd? _interstitialAd;

  @override
  AdState build() {
    _initAds();
    return const AdState();
  }

  Future<void> _initAds() async {
    await MobileAds.instance.initialize();
    await loadBannerAd();
    await loadInterstitialAd();
  }

  Future<void> loadBannerAd() async {
    BannerAd? previousAd = state.bannerAd;
    previousAd?.dispose();

    BannerAd? newBannerAd;
    try {
      newBannerAd = BannerAd(
        adUnitId: _getBannerAdUnitId(),
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (_) {
            if (newBannerAd != null) {
              state = state.copyWith(
                bannerAd: newBannerAd,
                isBannerAdReady: true,
              );
            }
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            state = state.copyWith(bannerAd: null, isBannerAdReady: false);
          },
        ),
      );

      await newBannerAd.load();
    } catch (e) {
      newBannerAd?.dispose();
      state = state.copyWith(bannerAd: null, isBannerAdReady: false);
    }
  }

  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: _getInterstitialAdUnitId(),
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          state = state.copyWith(isInterstitialAdReady: true);
        },
        onAdFailedToLoad: (error) {
          state = state.copyWith(isInterstitialAdReady: false);
          loadInterstitialAd();
        },
      ),
    );
  }

  Future<void> showInterstitialAd({
    VoidCallback? onAdDismissed,
    VoidCallback? onAdFailed,
  }) async {
    if (_interstitialAd == null) {
      onAdFailed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        state = state.copyWith(isInterstitialAdReady: false);
        loadInterstitialAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        state = state.copyWith(isInterstitialAdReady: false);
        loadInterstitialAd();
        onAdFailed?.call();
      },
    );

    await _interstitialAd!.show();
  }

  String _getBannerAdUnitId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/6300978111'; // Test ID
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/2934735716'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  String _getInterstitialAdUnitId() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/1033173712'; // Test ID
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/4411468910'; // Test ID
    }
    throw UnsupportedError('Unsupported platform');
  }

  void cleanup() {
    state.bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
