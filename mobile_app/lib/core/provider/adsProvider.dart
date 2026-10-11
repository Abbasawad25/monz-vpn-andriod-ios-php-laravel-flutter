import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:provider/provider.dart';

import 'vpnProvider.dart';

class AdsProvider extends ChangeNotifier {
  InterstitialAd? _intersAd1;
  InterstitialAd? _intersAd2;
  InterstitialAd? _intersAd3;

  bool _footerBannerShow = false;
  BannerAd? _bannerAd;

  InterstitialAd? get intersAd1 => _intersAd1;
  InterstitialAd? get intersAd2 => _intersAd2;
  InterstitialAd? get intersAd3 => _intersAd3;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    notifyListeners();
  }

  get footBannerShow => _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  void _intersAd1Create() {
    InterstitialAd.load(
      adUnitId: inters2,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _intersAd1 = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _intersAd1 = null;
          Future.delayed(const Duration(seconds: 2), () => _intersAd1Create());
        },
      ),
    );
  }

  void _intersAd2Create() {
    InterstitialAd.load(
      adUnitId: inters2,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _intersAd2 = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _intersAd2 = null;
          Future.delayed(const Duration(seconds: 2), () => _intersAd2Create());
        },
      ),
    );
  }

  void _intersAd3Create() {
    InterstitialAd.load(
      adUnitId: inters3,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _intersAd3 = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _intersAd3 = null;
          Future.delayed(const Duration(seconds: 2), () => _intersAd3Create());
        },
      ),
    );
  }

  static void initAds(BuildContext context) {
    AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);
    adsProvider._intersAd1Create();
    adsProvider._intersAd2Create();
    adsProvider._intersAd3Create();
  }

  void showAd1(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (_intersAd1 != null) {
      _intersAd1!.show();
    }
  }

  void showAd2(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (_intersAd2 != null) {
      _intersAd2!.show();
    }
  }

  void showAd3(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (_intersAd3 != null) {
      _intersAd3!.show();
    }
  }

  static Widget adWidget(BuildContext context, {String? bannerId, AdSize adSize = AdSize.banner}) {
    VpnProvider vpnProvider = Provider.of(context, listen: false);
    if (vpnProvider.isPro) {
      return const SizedBox.shrink();
    } else {
      return BannerAd(
        adUnitId: bannerId ?? banner1,
        size: adSize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {},
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
          },
          onAdOpened: (Ad ad) {},
          onAdClosed: (Ad ad) {},
        ),
      ).build() as Widget;
    }
  }

  static Widget adbottomSpace() {
    return Consumer<AdsProvider>(
      builder: (context, value, child) => value.footBannerShow
          ? const SizedBox(
              height: 50,
            )
          : const SizedBox.shrink(),
    );
  }

  static void initBottomAd(BuildContext context, {String? bannerId, AdSize adsize = AdSize.banner}) {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);

    if (vpnProvider.isPro) {
      adsProvider.removeBanner();
      return;
    } else {
      BannerAd bannerAd = BannerAd(
        adUnitId: bannerId ?? banner1,
        size: adsize,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            adsProvider.footBannerShow = true;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            adsProvider.footBannerShow = false;
          },
          onAdOpened: (Ad ad) {},
          onAdClosed: (Ad ad) {},
        ),
      );
      adsProvider._bannerAd = bannerAd;
      bannerAd.load();
    }
  }

  void removeBanner() {
    footBannerShow = false;
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  @override
  void dispose() {
    _intersAd1?.dispose();
    _intersAd2?.dispose();
    _intersAd3?.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }
}
