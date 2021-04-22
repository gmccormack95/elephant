import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {

  static InterstitialAd _interstitialAd;

  static initalize() {
    if(MobileAds.instance == null) {
      MobileAds.instance.initialize();
    }
  }

  static BannerAd createBannerAd() {
    BannerAd bannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) => print('Ad loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => ad.dispose(),
        onApplicationExit: (Ad ad) => ad.dispose(),
      )
    );

    return bannerAd;
  }

  static InterstitialAd createInterstitialAd() {
    InterstitialAd interstitialAd = InterstitialAd(
      adUnitId: interstitialAdUnitId,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdOpened: (Ad ad) => print('Ad opened.'),
        onAdClosed: (Ad ad) => ad.dispose(),
        onApplicationExit: (Ad ad) => ad.dispose()
      )
    );

    return interstitialAd;
  }

  static void showInterstitailAd() async {
    _interstitialAd?.dispose();
    _interstitialAd = null;

    if(_interstitialAd == null) _interstitialAd = createInterstitialAd();
    await _interstitialAd.load();
    await _interstitialAd.show();
  }

  static String get bannerAdUnitId {
    /* REAL ADS
    if (Platform.isAndroid) {
      return "ca-app-pub-5645168269123923/3833030462";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5645168269123923/5558542652";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
    */

    //TEST ADS
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    /* REAL ADS
    if (Platform.isAndroid) {
      return "ca-app-pub-5645168269123923/74294946962";
    } else if (Platform.isIOS) {
      return "ca-app-pub-5645168269123923/1007734181";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
    */

    //TEST ADS
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

}