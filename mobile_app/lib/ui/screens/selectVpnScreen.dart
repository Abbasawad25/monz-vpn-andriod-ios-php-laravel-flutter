import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/core/https/vpnServerHttp.dart';
import 'package:nizvpn/core/models/vpnConfig.dart';
import 'package:nizvpn/core/models/vpnServer.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:nizvpn/ui/components/customImage.dart';
import 'package:nizvpn/ui/screens/subscriptionDetailScreen.dart';
import 'package:provider/provider.dart';

class SelectVpnScreen extends StatefulWidget {
  @override
  _SelectVpnScreenState createState() => _SelectVpnScreenState();
}

class _SelectVpnScreenState extends State<SelectVpnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(LineIcons.angle_left), onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text("Select VPN"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          VpnProvider provider = Provider.of(context, listen: false);
          provider.refreshServers(context);
        },
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(20),
          children: [
            Text("Free Server"),
            ColumnDivider(space: 5),
            freeListWidget(),
            ColumnDivider(space: 15),
            Text("Pro Server"),
            ColumnDivider(space: 5),
            proListWidget(),
          ],
        ),
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  Widget freeListWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        if (value.vpnServers != null && value.vpnServers.length > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: value.vpnServers
                .where((element) => element.status == 0)
                .map(
                  (e) => VpnServerButton(
                    vpnServer: e,
                    active: (value?.vpnConfig?.id ?? 0) == (e?.id ?? 0),
                  ),
                )
                .toList()
                .cast(),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            height: 200,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget proListWidget() {
    return Consumer<VpnProvider>(
      builder: (context, value, child) {
        if (value.vpnServers != null && value.vpnServers.length > 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: value.vpnServers
                .where((element) => element.status == 1)
                .map(
                  (e) => VpnServerButton(
                    vpnServer: e,
                    active: (value?.vpnConfig?.id ?? 0) == (e?.id ?? 0),
                  ),
                )
                .toList()
                .cast(),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            height: 200,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class VpnServerButton extends StatelessWidget {
  final VpnServer vpnServer;
  final bool active;

  const VpnServerButton({Key key, this.vpnServer, this.active}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: FlatButton(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        onPressed: () => _vpnSelectClick(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: Theme.of(context).primaryColor)),
        child: Row(
          children: [
            vpnServer?.flag == null
                ? SizedBox.shrink()
                : (vpnServer.flag.toLowerCase().startsWith("http")
                    ? CustomImage(
                        url: vpnServer.flag,
                        height: 30,
                        width: 30,
                        fit: BoxFit.scaleDown,
                      )
                    : Image.asset(
                        "assets/icons/flags/${vpnServer.flag}.png",
                        height: 30,
                        width: 30,
                      )),
            RowDivider(),
            Expanded(child: Text(vpnServer?.name ?? "Select server...")),
            vpnServer.status == 1
                ? Container(
                    child: Image.asset(
                      "assets/icons/crown.png",
                      width: 30,
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                  )
                : SizedBox.shrink(),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                color: (active ?? false) ? Theme.of(context).primaryColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).primaryColor),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _vpnSelectClick(BuildContext context) async {
    VpnProvider provider = Provider.of(context, listen: false);
    if (vpnServer.status == 1 && !provider.isPro) {
      return NAlertDialog(
        title: Text("Not Allowed"),
        content: Text("Please purchase subscription to get more high speed servers"),
        actions: [
          FlatButton(
            child: Text("Go Premium"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen())),
          ),
        ],
      ).show(context);
    }
    VpnConfig resp = await CustomProgressDialog.future(
      context,
      future: VpnServerHttp(context).detailVpn(vpnServer.slug),
      dismissable: false,
      loadingWidget: Center(
        child: Container(
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
        ),
      ),
    );

    AdsProvider adsProvider = Provider.of(context, listen: false);
    if (resp != null) {
      provider.vpnConfig = resp; 
      adsProvider.showAd3(context); 
      if (await NVPN.isConnected()) NVPN.stopVpn();
      Navigator.pop(context);
      FirebaseAnalytics().logEvent(name: "selected_country", parameters: {"country": resp.name, "slug": resp.slug, "id": resp.id});
    } else {
      NAlertDialog(
        title: Text("Can't Reach Server"),
        content: Text("Check your internet connection and try again!"),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Understand"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          )
        ],
      ).show(context);
    }
  }
}
