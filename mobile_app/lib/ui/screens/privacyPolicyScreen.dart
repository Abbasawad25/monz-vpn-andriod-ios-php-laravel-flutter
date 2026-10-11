import 'package:flutter/material.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/main.dart';
import 'package:nizvpn/ui/components/customCard.dart';
import 'package:nizvpn/ui/components/customDivider.dart';

class PrivacyPolicyIntroScreen extends StatefulWidget {
  final RootState rootState;

  const PrivacyPolicyIntroScreen({Key key, this.rootState}) : super(key: key);

  @override
  _PrivacyPolicyIntroScreenState createState() => _PrivacyPolicyIntroScreenState();
}

class _PrivacyPolicyIntroScreenState extends State<PrivacyPolicyIntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomCard(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Your privacy comes first", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(20),
                  children: [
                    Text("Nerd VPN collects a minimal amount of data to offer you a fast and reliable VPN service."),
                    ColumnDivider(),
                    Text("We Collect :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ColumnDivider(space: 5),
                    _privacyPointWidget("Personal Information",
                        "If you seek technical support via email, we will get your email address and the information you provided, but it will be deleted within 48 hours after handling the technical support"),
                    ColumnDivider(),
                    _privacyPointWidget("Diagnostics",
                        "To improve the quality of our products and enhance the user experience, we collect diagnostic information and crash reports on our apps, including connection events and error code."),
                    ColumnDivider(),
                    _privacyPointWidget("Third Parties",
                        "To improve the quality of our products and enhance the user experience, we collect diagnostic information and crash reports on our apps, including connection events and error code."),
                    ColumnDivider(),
                    Text("We do not collect logs of your activity, including no logging of browsing history,traffic destination, data, content, or DNS queries.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: double.infinity,
                child: FlatButton(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                  child: Text(
                    "Accept and Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _accAndContinueClick,
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }

  void _accAndContinueClick() {
    Preferences.init().then((value) {
      widget.rootState.setState(() {
        value.acceptPrivacyPolicy();
      });
    });
  }

  Widget _privacyPointWidget(String title, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: 3),
          decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
          width: 15,
          height: 15,
        ),
        RowDivider(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
              Text(message ?? ""),
            ],
          ),
        )
      ],
    );
  }
}
