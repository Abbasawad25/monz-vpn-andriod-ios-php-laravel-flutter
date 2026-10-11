import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nizvpn/core/provider/adsProvider.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/ui/components/customDivider.dart';
import 'package:package_info/package_info.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(LineIcons.angle_left), onPressed: () => Navigator.pop(context)),
        elevation: 0,
        title: Text("About"),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        children: [
          Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(text: "Nerd ", style: GoogleFonts.poppins(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600)),
                TextSpan(text: "VPN", style: GoogleFonts.poppins(color: primaryColor, fontSize: 30, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text("Version ${snapshot.data.version}", textAlign: TextAlign.center);
              } else {
                return SizedBox.shrink();
              }
            },
          ),
          ColumnDivider(),
          Image.asset(
            "assets/images/coach.png",
            height: 200,
          ),
          ColumnDivider(),
          Text(
            "Nerd VPN is a free services to secure your connection and circumvent censorship. Check out our Play Store page for more info.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
      bottomNavigationBar: AdsProvider.adbottomSpace(),
    );
  }
}
