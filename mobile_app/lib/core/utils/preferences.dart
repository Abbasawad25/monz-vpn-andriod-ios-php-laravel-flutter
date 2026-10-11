import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  final SharedPreferences shared;
  Preferences(this.shared);

  String get vpnToken => shared.getString("token");
  bool get privacyPolicy => shared.getBool("privacy-policy") ?? false;

  Future saveVpnToken(String token) async {
    await shared.setString("token", token);
  }

  Future acceptPrivacyPolicy() async {
    await shared.setBool("privacy-policy", true);
  }

  static Future<Preferences> init() => SharedPreferences.getInstance().then((value) => Preferences(value));
}
