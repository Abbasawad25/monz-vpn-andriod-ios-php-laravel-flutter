import 'package:flutter/material.dart';
import 'package:nizvpn/core/https/httpConnection.dart';
import 'package:nizvpn/core/models/vpnConfig.dart';
import 'package:nizvpn/core/models/vpnServer.dart';
import 'package:nizvpn/core/resources/environment.dart';

class VpnServerHttp extends HttpConnection {
  VpnServerHttp(BuildContext context) : super(context);

  Future<List<VpnServer>> allServer() async {
    ApiResponse resp = await get(endpoint + "allserver");
    if (resp.success) {
      return resp.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<List<VpnServer>> allProServer() async {
    ApiResponse resp = await get(endpoint + "allserver/pro");
    if (resp.success) {
      return resp.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<List<VpnServer>> allFreeServer() async {
    ApiResponse resp = await get(endpoint + "allserver/free");
    if (resp.success) {
      return resp.data.map((e) => VpnServer.fromJson(e)).toList().cast<VpnServer>();
    }
    return [];
  }

  Future<VpnConfig> randomVpn() async {
    ApiResponse resp = await get(endpoint + "detail/random");
    if (resp.success) {
      return VpnConfig.fromJson(resp.data);
    }
    return null;
  }

  Future<VpnConfig> detailVpn(String slug) async {
    ApiResponse resp = await get(endpoint + "detail/$slug");
    if (resp.success) {
      return VpnConfig.fromJson(resp.data);
    }
    return null;
  }
}
