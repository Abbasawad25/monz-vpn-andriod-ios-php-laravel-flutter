import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:provider/provider.dart';

import 'vpnProvider.dart';

class AdsProvider extends ChangeNotifier {
  InterstitialAd intersAd1;
  InterstitialAd intersAd2;
  InterstitialAd intersAd3;

  bool _footerBannerShow = false;
  BannerAd _bannerAd;

  set footBannerShow(bool value) {
    _footerBannerShow = value;
    notifyListeners();
  }

  get footBannerShow => _footerBannerShow;

  get bannerIsAvailable => _bannerAd != null;

  InterstitialAd _intersAd1Create() => InterstitialAd(
        adUnitId: inters2,
        // targetingInfo: MobileAdTargetingInfo(testDevices: ["40AF1070204CF1D2C41238AF67F67491"]),
        listener: (event) {
          if (event == MobileAdEvent.closed || event == MobileAdEvent.failedToLoad) {
            intersAd1.dispose();
            intersAd1 = _intersAd1Create();
            intersAd1.load();
          }
        },
      );

  InterstitialAd _intersAd2Create() => InterstitialAd(
        adUnitId: inters2,
        // targetingInfo: MobileAdTargetingInfo(testDevices: ["40AF1070204CF1D2C41238AF67F67491"]),
        listener: (event) {
          if (event == MobileAdEvent.closed || event == MobileAdEvent.failedToLoad) {
            intersAd2.dispose();
            intersAd2 = _intersAd1Create();
            intersAd2.load();
          }
        },
      );

  InterstitialAd _intersAd3Create() => InterstitialAd(
        adUnitId: inters3,
        // targetingInfo: MobileAdTargetingInfo(testDevices: ["40AF1070204CF1D2C41238AF67F67491"]),
        listener: (event) {
          if (event == MobileAdEvent.closed || event == MobileAdEvent.failedToLoad) {
            intersAd3.dispose();
            intersAd3 = _intersAd1Create();
            intersAd3.load();
          }
        },
      );

  static void initAds(BuildContext context) {
    AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);

    adsProvider.intersAd1 = adsProvider._intersAd1Create();
    adsProvider.intersAd2 = adsProvider._intersAd2Create();
    adsProvider.intersAd3 = adsProvider._intersAd3Create();

    adsProvider.intersAd1.load();
    adsProvider.intersAd2.load();
    adsProvider.intersAd3.load();
  }

  void showAd1(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (await intersAd1.isLoaded()) {
      intersAd1.show();
    } else {
      intersAd1.load();
    }
  }

  void showAd2(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (await intersAd2.isLoaded()) {
      intersAd2.show();
    } else {
      intersAd2.load();
    }
  }

  void showAd3(BuildContext context) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    if (vpnProvider.isPro) return;
    if (await intersAd3.isLoaded()) {
      intersAd3.show();
    } else {
      intersAd3.load();
    }
  }

  static Widget adWidget(BuildContext context, {String bannerId = banner1, AdmobBannerSize adsize = AdmobBannerSize.BANNER}) {
    VpnProvider vpnProvider = Provider.of(context, listen: false);
    if (vpnProvider.isPro) {
      return SizedBox.shrink();
    } else {
      return AdmobBanner(adUnitId: bannerId, adSize: adsize);
    }
  }

  static Widget adbottomSpace() {
    return Consumer<AdsProvider>(
      builder: (context, value, child) => value.footBannerShow
          ? SizedBox(
              height: 50,
            )
          : SizedBox.shrink(),
    );
  }

  static void initBottomAd(BuildContext context, {String bannerId = banner1, AdSize adsize = AdSize.banner}) {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);

    if (vpnProvider.isPro) {
      adsProvider.removeBanner();
      return;
    } else {
      adsProvider._bannerAd = BannerAd(
        adUnitId: bannerId,
        // targetingInfo: MobileAdTargetingInfo(testDevices: ["40AF1070204CF1D2C41238AF67F67491"]),
        size: adsize,
        listener: (event) {
          VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
          if (vpnProvider.isPro) {
            initBottomAd(context, bannerId: bannerId, adsize: adsize);
          }
          if (event == MobileAdEvent.failedToLoad) {
            adsProvider.footBannerShow = false;
          } else if (event == MobileAdEvent.loaded) {
            adsProvider.footBannerShow = true;
          }
        },
      );

      adsProvider._bannerAd
        ..load()
        ..show();
    }
  }

  void removeBanner() {
    footBannerShow = false;
    _bannerAd.dispose();
    _bannerAd = null;
  }
}
