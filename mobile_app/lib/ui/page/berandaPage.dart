import 'dart:async';
import 'dart:math';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/core/models/vpnStatus.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/environment.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:nizvpn/ui/components/customImage.dart';
import 'package:nizvpn/core/resources/nerdVpnIcons.dart';
import 'package:nizvpn/ui/screens/selectVpnScreen.dart';
import 'package:provider/provider.dart';

class BerandaPage extends StatefulWidget {
  @override
  _BerandaPageState createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  StreamSubscription stageStream;

  @override
  void didChangeDependencies() {
    VpnProvider.refreshInfoVPN(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    stageStream = NVPN.vpnStageSnapshot().listen((event) => VpnProvider.refreshInfoVPN(context, event));
    super.initState();
  }

  @override
  void dispose() {
    stageStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: _body(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ColumnDivider(space: 20),
        _topMessageWidget(),
        ColumnDivider(space: 20),
        SizedBox(
          height: 200,
          child: _connectButtonWidget(),
        ),
        ColumnDivider(space: 20),
        _currentLocationWidget(),
        _connectionInfo(),
        ColumnDivider(space: 80)
      ],
    );
  }

  Widget _connectionInfo() {
    return Container(
      height: 120,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: StreamBuilder<VpnStatus>(
        stream: NVPN.vpnStatusSnapshot(),
        builder: (context, snapshot) {
          String byteIn = "0,0 kB - 0,0 kB/s";
          String byteOut = "0,0 kB - 0,0 kB/s";

          if (snapshot.hasData) {
            byteIn = snapshot.data.byteIn.trim().length == 0 ? "0,0 kB - 0,0 kB/s" : snapshot.data.byteIn.trim();
            byteOut = snapshot.data.byteOut.trim().length == 0 ? "0,0 kB - 0,0 kB/s" : snapshot.data.byteOut.trim();
          }
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Download",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteIn,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Upload",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      byteOut,
                      style: TextStyle(fontSize: 12, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _currentLocationWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Current Location",
            style: TextStyle(fontSize: 12),
          ),
          ColumnDivider(
            space: 5,
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) => SizedBox(
              height: 50,
              child: FlatButton(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: grey,
                  ),
                ),
                child: Row(
                  children: [
                    value?.vpnConfig?.flag == null
                        ? SizedBox.shrink()
                        : (value.vpnConfig.flag.toLowerCase().startsWith("http")
                            ? CustomImage(
                                url: value.vpnConfig.flag,
                                height: 30,
                                width: 30,
                                fit: BoxFit.scaleDown,
                              )
                            : Image.asset(
                                "assets/icons/flags/${value.vpnConfig.flag}.png",
                                height: 30,
                                width: 30,
                              )),
                    RowDivider(),
                    Expanded(child: Text(value?.vpnConfig?.name ?? "Select server..."))
                  ],
                ),
                onPressed: _changeLocationClick,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _connectButtonWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        Color buttonColor = greyLittleWhite;
        switch (value?.vpnStage ?? NVPN.vpnDisconnected) {
          case "":
            break;
          case NVPN.vpnConnected:
            buttonColor = primaryColor;
            break;
          case NVPN.vpnDisconnected:
            buttonColor = greyLittleWhite;
            break;
          default:
            buttonColor = Colors.orange;
            break;
        }
        return Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.1),
                ),
              ],
              shape: BoxShape.circle,
            ),
            child: FlatButton(
              color: buttonColor,
              shape: CircleBorder(),
              onPressed: () => _connectVPNClick(value),
              child: Icon(
                NerdVPNIcon.power,
                size: 130,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _topMessageWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Consumer<VpnProvider>(
        builder: (context, value, child) {
          String tulisan = "Unprotected";
          Color color = Colors.red;
          if (value.vpnStage == NVPN.vpnConnected) {
            tulisan = "Protected";
            color = Colors.green;
          } else if (value.vpnStage == NVPN.vpnDisconnected) {
            tulisan = "Unprotected";
            color = Colors.red;
          } else {
            if (value.vpnStage != null && value.vpnStage.trim().length > 0) {
              tulisan = value.vpnStage.replaceAll("_", " ");
              color = Colors.orange;
            }
          }
          return RichText(
            text: TextSpan(children: [
              TextSpan(text: "Welcome,\n", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              TextSpan(text: "Your connection ", style: GoogleFonts.poppins(fontSize: 15, color: Colors.black)),
              TextSpan(text: tulisan.toUpperCase(), style: GoogleFonts.poppins(fontSize: 15, color: color)),
            ]),
          );
        },
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: "Nerd ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
              TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 18, fontWeight: FontWeight.w600)),
            ]),
          ),
          Consumer<VpnProvider>(
            builder: (context, value, child) {
              if (value.isPro) {
                return Positioned(
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/crown.png",
                        height: 20,
                        width: 20,
                      ),
                    ],
                  ),
                  right: 0,
                );
              }
              return SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }

  void _connectVPNClick(VpnProvider vpnProvider) async {
    AdsProvider adsProvider = Provider.of(context, listen: false);
    if (vpnProvider.vpnStage != NVPN.vpnDisconnected && vpnProvider.vpnStage.length > 0) {
      if (vpnProvider.vpnStage == NVPN.vpnConnected) {
        var resp = await NAlertDialog(
          dialogStyle: DialogStyle(titleDivider: true, contentPadding: EdgeInsets.only()),
          title: Text("Disconnect?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AdsProvider.adWidget(context, bannerId: banner2, adsize: AdmobBannerSize.MEDIUM_RECTANGLE),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text("Your connection must be UNPROTECTED!, are you sure to disconnect?"),
              ),
            ],
          ),
          actions: [
            FlatButton(
              child: Text("Disconnect"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        ).show(context);

        if (resp ?? false) {
          NVPN.stopVpn();
          adsProvider.showAd2(context);
        }
      } else {
        NVPN.stopVpn();
      }
    } else {
      if (vpnProvider.vpnConfig != null) {
        if (vpnProvider.vpnConfig.status == 1 && !vpnProvider.isPro) {
          return VpnProvider.renewSubs(context);
        }
        if (vpnProvider.vpnConfig.config == null && vpnProvider.vpnConfig.slug != null) {
          await CustomProgressDialog.future(
            context,
            future: vpnProvider.setConfig(context, vpnProvider.vpnConfig.slug),
            dismissable: false,
            loadingWidget: Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
          return _connectVPNClick(vpnProvider);
        }
      } else {
        return NAlertDialog(
          title: Text("Unknown Server"),
          content: Text("Please select a server to connect!"),
          actions: [
            FlatButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectVpnScreen())),
                child: Text("Choose server"),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)))
          ],
        ).show(context);
      }

      Future.delayed(Duration(seconds: 5)).then((value) {
        if (Random().nextBool()) {
          NAlertDialog(
            title: Text("Do you like me?"),
            content: Text("Why don't you drop me 5 stars and cheers me up \😊"),
            actions: [
              FlatButton(onPressed: () => Navigator.pop(context), child: Text("Already did!")),
              FlatButton(
                child: Text("I'm Doing it"),
                onPressed: () {
                  InAppReview.instance.openStoreListing();
                  Navigator.pop(context);
                },
              ),
            ],
          ).show(context);
        }
      });
      adsProvider.showAd1(context);
      await NVPN.startVpn(vpnProvider.vpnConfig);
      FirebaseAnalytics().logEvent(
        name: "connected",
        parameters: {"country": vpnProvider.vpnConfig.name, "slug": vpnProvider.vpnConfig.slug, "id": vpnProvider.vpnConfig.id},
      );
    }
  }

  void _changeLocationClick() async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => SelectVpnScreen()));
  }
}
