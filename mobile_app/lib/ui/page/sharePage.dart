import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _customAppBarWidget(),
          _inviteFriendsWidget(),
        ],
      ),
    );
  }

  Widget _inviteFriendsWidget() {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                "assets/images/vpnshare.png",
                height: 200,
              ),
              ColumnDivider(),
              Text(
                "Share free VPN experince",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                "Help your friend stay anonymous, access Restricted content and enjoy streaming services from all regions with Nerd VPN.",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
              ColumnDivider(),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(.3),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      )
                    ],
                  ),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    color: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "Share With Friend",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: _shareClick,
                  ),
                ),
              ),
              ColumnDivider(space: 80)
            ],
          ),
        ),
      ),
    );
  }

  Widget _customAppBarWidget() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(text: "Invite ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600)),
          TextSpan(text: "Friends", style: GoogleFonts.poppins(color: primaryColor, fontSize: 18, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  void _shareClick() async {
    PackageInfo pinfo = await PackageInfo.fromPlatform();
    Share.share(
      "Check this cool vpn!\nhttps://play.google.com/store/apps/details?id=" + (pinfo?.packageName ?? ""),
    );
  }
}
