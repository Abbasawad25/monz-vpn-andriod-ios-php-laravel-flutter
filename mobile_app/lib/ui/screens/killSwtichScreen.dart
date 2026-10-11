import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:nizvpn/core/resources/warna.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/ui/components/customDivider.dart';

class KillSwitchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text("Kill Switch"),
        leading: IconButton(
          icon: Icon(LineIcons.angle_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        physics: BouncingScrollPhysics(),
        children: [
          Text(
            "Follow the instruction to block unprotected traffic",
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          ColumnDivider(space: 30),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.3),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("1. Open Android settings by clicking the button bellow."),
                ColumnDivider(),
                Text("2. Choose Nerd VPN settings."),
                ColumnDivider(),
                Text("3. Enable both 'Always-on VPN' and 'Block connection without VPN'."),
                ColumnDivider(space: 15),
                FlatButton(
                  color: primaryColor,
                  child: Text(
                    "Open Android Settings",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: NVPN.openKillSwitch,
                  shape: StadiumBorder(),
                )
              ],
            ),
          ),
          ColumnDivider(),
          Text(
            "If these options are missing, this feature not available on your devices.",
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
