import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/provider/purchaseProvider.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/ui/screens/privacyPolicyScreen.dart';
import 'package:provider/provider.dart';

import 'ui/screens/mainScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runZoned(() {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => VpnProvider()),
        ChangeNotifierProvider(create: (context) => PurchaseProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
        ChangeNotifierProvider(create: (context) => MainScreenProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: primaryColor,
          fontFamily: GoogleFonts.poppins().fontFamily,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: Root(),
      ),
    ));
  }, onError: Crashlytics.instance.recordError);
}

class Root extends StatefulWidget {
  @override
  RootState createState() => RootState();
}

class RootState extends State<Root> {
  bool ready = false;
  @override
  void initState() {
    FirebaseAnalytics().logAppOpen();
    Admob.initialize(appId);

    Future.delayed(Duration.zero).then((value) async {
      InAppUpdate.checkForUpdate().then((value) {
        if (value.flexibleUpdateAllowed) return InAppUpdate.startFlexibleUpdate().then((value) => InAppUpdate.completeFlexibleUpdate());
        if (value.immediateUpdateAllowed) return InAppUpdate.performImmediateUpdate();
      });

      await PurchaseProvider.initPurchase(context);
      await VpnProvider.refreshInfoVPN(context);

      AdsProvider.initAds(context);
      if (!ready)
        setState(() {
          ready = true;
        });
    });

    Future.delayed(Duration(seconds: 8)).then((value) {
      if (!ready)
        setState(() {
          ready = true;
        });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ready
        ? FutureBuilder<Preferences>(
            future: Preferences.init(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.privacyPolicy) {
                  return MainScreen();
                } else {
                  return PrivacyPolicyIntroScreen(rootState: this);
                }
              } else {
                return SplashScreen();
              }
            },
          )
        : SplashScreen();
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(text: "Nerd ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w600)),
            TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 24, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
    );
  }
}
