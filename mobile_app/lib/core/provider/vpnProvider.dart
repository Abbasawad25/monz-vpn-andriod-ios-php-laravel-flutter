import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:nizvpn/core/https/vpnServerHttp.dart';
import 'package:nizvpn/core/models/vpnConfig.dart';
import 'package:nizvpn/core/models/vpnServer.dart';
import 'package:nizvpn/core/utils/NizVPN.dart';
import 'package:nizvpn/core/utils/preferences.dart';
import 'package:nizvpn/ui/screens/subscriptionDetailScreen.dart';
import 'package:provider/provider.dart';

class VpnProvider extends ChangeNotifier {
  bool _isConnected;
  VpnConfig _vpnConfig;
  String _vpnStage;
  List<VpnServer> _vpnServers;

  DateTime _proLimitDate;

  ///Refresh everything (Pro status, VPNStage and VPN Servers)
  static Future<void> refreshInfoVPN(BuildContext context, [String stage]) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    vpnProvider.isConnected = await NVPN.isConnected();
    vpnProvider.vpnStage = stage ?? await NVPN.stage();
    if (vpnProvider.vpnConfig == null) {
      Preferences.init().then((value) async {
        if (value.vpnToken != null) {
          var resp = await vpnProvider.setConfig(context, value.vpnToken);

          ///Check if server is PRO but Account is Free
          if (resp.status == 1 && !vpnProvider.isPro) {
            if (await NVPN.isConnected()) {
              NVPN.stopVpn();
              renewSubs(context);
            }
          }
        } else {
          ///If user open app from the first time (without SharedPref vpn)
          vpnProvider.setRandom(context);
        }
      });
    }
    if (vpnProvider.vpnServers == null || vpnProvider.vpnServers.length == 0) vpnProvider.refreshServers(context);
  }

  ///Set Pro limit date and hit the notify (do it after init the purchase information)
  set proLimitDate(DateTime time) {
    _proLimitDate = time;
    notifyListeners();
  }

  ///Set List of servers and hit the notify
  set vpnServers(List<VpnServer> listVpnServer) {
    _vpnServers = listVpnServer;
    notifyListeners();
  }

  ///Set current VPNConfig and hit the notify
  set vpnConfig(VpnConfig vpnConfig) {
    _vpnConfig = vpnConfig;
    Preferences.init().then((value) => value.saveVpnToken(vpnConfig.slug));
    notifyListeners();
  }

  ///Set current isConnected status and hit the notify
  set isConnected(bool status) {
    _isConnected = status;
    notifyListeners();
  }

  ///Set current VPNStage and hit the notify
  set vpnStage(String stage) {
    _vpnStage = stage;
    notifyListeners();
  }

  ///Set VPNConfig with random configuration that taken from Server!
  Future<void> setRandom(BuildContext context) async {
    var resp = await VpnServerHttp(context).randomVpn();
    if (resp != null) vpnConfig = resp;
  }

  ///Set VPNConfig that taken from Server by Slug
  Future<VpnConfig> setConfig(BuildContext context, String slug) async {
    var resp = await VpnServerHttp(context).detailVpn(slug);
    if (resp != null) vpnConfig = resp;
    return resp;
  }

  ///Refresh list of servers
  Future<void> refreshServers(BuildContext context) async {
    var resp = await VpnServerHttp(context).allServer();
    if (resp != null) vpnServers = resp;
  }

  ///Current VPNConfig
  VpnConfig get vpnConfig => _vpnConfig;

  ///List of servers
  List<VpnServer> get vpnServers => _vpnServers;

  ///Current Stage of connection
  String get vpnStage => _vpnStage != null ? _vpnStage.toLowerCase() : null;

  ///Check if VPN is Connected
  bool get isConnected => _isConnected;

  ///Check if User is PRO
  bool get isPro => proLimitDate != null ? DateTime.now().isBefore(proLimitDate) : false;

  ///Get pro limit date
  DateTime get proLimitDate => _proLimitDate;

  ///Dialog to tell that user's pro subscription is expired
  static Future renewSubs(BuildContext context, {String title, String message}) => NAlertDialog(
        content: Text(message ?? "Your pro subscription is expired, renew it to access more server!"),
        title: Text(title ?? "Ops!"),
        actions: [
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Text("Renew"),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SubscriptionDetailScreen()));
            },
          ),
          FlatButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Text("Continue as free"),
            onPressed: () {
              VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
              vpnProvider.vpnConfig = null;
              Navigator.pop(context);
            },
          ),
        ],
      ).show(context);
}
