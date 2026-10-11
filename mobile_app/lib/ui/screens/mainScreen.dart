import 'package:flutter/material.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/ui/components/customCard.dart';
import 'package:nizvpn/core/resources/nerdVpnIcons.dart';
import 'package:nizvpn/ui/components/customImage.dart';
import 'package:nizvpn/ui/page/berandaPage.dart';
import 'package:nizvpn/ui/page/pengaturanPage.dart';
import 'package:nizvpn/ui/page/sharePage.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        AdsProvider adsProvider = Provider.of<AdsProvider>(context, listen: false);
        if (value.isPro) {
          if (adsProvider.bannerIsAvailable) {
            adsProvider.removeBanner();
          }
        } else {
          if (!adsProvider.bannerIsAvailable) {
            AdsProvider.initBottomAd(context);
          }
        }
        return child;
      },
      child: WillPopScope(
        onWillPop: () async {
          MainScreenProvider provider = Provider.of<MainScreenProvider>(context, listen: false);
          if (provider.pageIndex > 0) {
            provider.pageIndex--;
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: BottomImageCityWidget(),
              ),
              Column(
                children: [
                  Expanded(
                    child: Consumer<MainScreenProvider>(
                      builder: (context, value, child) => [
                        BerandaPage(),
                        SharePage(),
                        PengaturanPage(),
                      ][value.pageIndex],
                    ),
                  ),
                  AdsProvider.adbottomSpace(),
                ],
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _customBottomNavBar(),
        ),
      ),
    );
  }

  Widget _customBottomNavBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomCard(
          margin: EdgeInsets.symmetric(horizontal: 20),
          radius: 20,
          child: SizedBox(
            height: 60,
            child: Consumer<MainScreenProvider>(
              builder: (context, value, child) => Row(
                children: [
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        NerdVPNIcon.home,
                        color: value.pageIndex == 0 ? Theme.of(context).primaryColor : grey,
                      ),
                      onPressed: () {
                        value.pageIndex = 0;
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        NerdVPNIcon.gift,
                        color: value.pageIndex == 1 ? Theme.of(context).primaryColor : grey,
                      ),
                      onPressed: () {
                        value.pageIndex = 1;
                      },
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(
                        NerdVPNIcon.settings,
                        color: value.pageIndex == 2 ? Theme.of(context).primaryColor : grey,
                      ),
                      onPressed: () {
                        value.pageIndex = 2;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        AdsProvider.adbottomSpace(),
      ],
    );
  }
}

class MainScreenProvider extends ChangeNotifier {
  int _curIndex = 0;

  get pageIndex => _curIndex;
  set pageIndex(int value) {
    _curIndex = value;
    notifyListeners();
  }
}
