import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'ad_service.dart';
import 'admob_service.dart';

part 'ad_controller.g.dart';

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

@Riverpod(keepAlive: true)
class AdController extends AsyncNotifier<AdState> {
  late final AdService _adService;
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  bool _isLoadingBannerAd = false;
  int _bannerAdRetries = 0;
  static const _maxBannerAdRetries = 3;

  @override
  Future<AdState> build() async {
    _adService = AdMobService();
    await _adService.initialize();
    return const AdState();
  }

  Future<void> loadBannerAd() async {
    if (_isLoadingBannerAd) return;
    _isLoadingBannerAd = true;

    try {
      _bannerAd?.dispose();
      _bannerAd = await _adService.loadBannerAd();

      if (_bannerAd != null) {
        _bannerAdRetries = 0;
        if (state.hasValue) {
          state = AsyncData(
            AdState(
              bannerAd: _bannerAd,
              isBannerAdReady: true,
              isInterstitialAdReady: state.value!.isInterstitialAdReady,
            ),
          );
        }
      } else if (_bannerAdRetries < _maxBannerAdRetries) {
        _bannerAdRetries++;
        // Retry after a short delay
        await Future.delayed(Duration(seconds: _bannerAdRetries));
        _isLoadingBannerAd = false;
        await loadBannerAd();
      }
    } catch (e) {
      if (_bannerAdRetries < _maxBannerAdRetries) {
        _bannerAdRetries++;
        // Retry after a short delay
        await Future.delayed(Duration(seconds: _bannerAdRetries));
        _isLoadingBannerAd = false;
        await loadBannerAd();
      } else {
        if (state.hasValue) {
          state = AsyncData(
            AdState(
              bannerAd: null,
              isBannerAdReady: false,
              isInterstitialAdReady: state.value!.isInterstitialAdReady,
            ),
          );
        }
      }
    } finally {
      _isLoadingBannerAd = false;
    }
  }

  Future<void> loadInterstitialAd() async {
    _interstitialAd?.dispose();
    _interstitialAd = await _adService.loadInterstitialAd();

    if (state.hasValue && _interstitialAd != null) {
      state = AsyncData(
        AdState(
          bannerAd: state.value!.bannerAd,
          isBannerAdReady: state.value!.isBannerAdReady,
          isInterstitialAdReady: true,
        ),
      );
    }
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
        if (state.hasValue) {
          state = AsyncData(
            AdState(
              bannerAd: state.value!.bannerAd,
              isBannerAdReady: state.value!.isBannerAdReady,
              isInterstitialAdReady: false,
            ),
          );
        }
        loadInterstitialAd();
        onAdDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        if (state.hasValue) {
          state = AsyncData(
            AdState(
              bannerAd: state.value!.bannerAd,
              isBannerAdReady: state.value!.isBannerAdReady,
              isInterstitialAdReady: false,
            ),
          );
        }
        loadInterstitialAd();
        onAdFailed?.call();
      },
    );

    await _interstitialAd!.show();
  }

  void cleanupAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
  }
}
