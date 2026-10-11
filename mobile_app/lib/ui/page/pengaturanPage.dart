import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:line_icons/line_icons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:nizvpn/core/resources/nerdVpnIcons.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:nizvpn/ui/screens/aboutScreen.dart';
import 'package:nizvpn/ui/screens/killSwtichScreen.dart';
import 'package:nizvpn/ui/screens/subscriptionDetailScreen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PengaturanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20),
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("App", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  FutureBuilder<AndroidDeviceInfo>(
                    future: DeviceInfoPlugin().androidInfo,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.version.sdkInt > 24) {
                          return ListTile(
                            title: Text("Kill Switch"),
                            leading: Icon(NerdVPNIcon.settings, color: Colors.black),
                            onTap: () => _killSwitchClick(context),
                          );
                        }
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Consumer<VpnProvider>(
                    builder: (context, value, child) {
                      return (value.isPro ?? false)
                          ? SizedBox.shrink()
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ListTile(
                                  title: Text("Go Premium"),
                                  leading: Icon(LineIcons.diamond, color: Colors.black),
                                  onTap: () => _subscriptionClick(context),
                                )
                              ],
                            );
                    },
                  ),
                  ListTile(
                    title: Text("Check for update"),
                    leading: Icon(LineIcons.download, color: Colors.black),
                    onTap: () => _checkUpdateClick(context),
                  ),
                  Text("About Us", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ListTile(
                    title: Text("Privacy Policy"),
                    leading: Icon(LineIcons.shield, color: Colors.black),
                    onTap: () => _privacyPolicyClick(context),
                  ),
                  ListTile(
                    title: Text("Terms of Services"),
                    leading: Icon(LineIcons.sticky_note, color: Colors.black),
                    onTap: _tosClick,
                  ),
                  ListTile(
                    title: Text("About"),
                    leading: Icon(LineIcons.info_circle, color: Colors.black),
                    onTap: () => _aboutClick(context),
                  ),
                  ListTile(
                    title: Text("Rate Us"),
                    leading: Icon(LineIcons.star_o, color: Colors.black),
                    onTap: _rateUsClick,
                  ),
                  ColumnDivider(space: 90),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _killSwitchClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => KillSwitchScreen()));
  }

  void _subscriptionClick(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
  }

  void _checkUpdateClick(BuildContext context) async {
    AppUpdateInfo resp = await CustomProgressDialog.future(
      context,
      future: InAppUpdate.checkForUpdate(),
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

    if (resp?.updateAvailable ?? false) {
      if (resp.flexibleUpdateAllowed) return InAppUpdate.startFlexibleUpdate().then((value) => InAppUpdate.completeFlexibleUpdate());
      if (resp.immediateUpdateAllowed) return InAppUpdate.performImmediateUpdate();
    } else {
      NAlertDialog(
        title: Text("No Update"),
        content: Text("You are in the latest version!"),
        actions: [
          FlatButton(
            child: Text("Great!"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ).show(context);
    }
  }

  void _rateUsClick() async {
    // var value = await InAppReview.instance.isAvailable();
    // if (value ?? false) {
    // await InAppReview.instance.requestReview();
    // } else {
    await InAppReview.instance.openStoreListing();
    // }
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Settings",
        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _tosClick() {
    launch("https://nerdvpn.laskarmedia.id/term-of-services/");
  }

  void _privacyPolicyClick(context) {
    launch("https://nerdvpn.laskarmedia.id/privacy-policy-2/");
  }

  void _aboutClick(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
  }
}
