import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:nizvpn/core/provider/vpnProvider.dart';
import 'package:provider/provider.dart';

class PurchaseProvider extends ChangeNotifier {
  StreamSubscription<PurchasedItem> purchaseSnapshot;
  StreamSubscription<PurchaseResult> errorPurchaseSnapshot;
  FlutterInappPurchase get instance => FlutterInappPurchase.instance;

  List<IAPItem> _subscriptionProducts;
  bool _availableToPurchase = false;

  List<IAPItem> get subscriptionProducts => _subscriptionProducts;

  set subscriptionProducts(List<IAPItem> products) {
    _subscriptionProducts = products;
    notifyListeners();
  }

  bool get availableToPurchase => _availableToPurchase;

  set availableToPurchase(bool value) {
    _availableToPurchase = value;
    notifyListeners();
  }

  static Future initPurchase(BuildContext context) async {
    PurchaseProvider purchaseProvider = Provider.of<PurchaseProvider>(context, listen: false);
    return purchaseProvider.init(context);
  }

  Future init(BuildContext context) async {
    await instance.initConnection;
    await fetchProducts();
    await refreshProStatus(context);
    purchaseSnapshot = FlutterInappPurchase.purchaseUpdated.listen((event) {
      _verifyPurchase(context, event);
    });
    errorPurchaseSnapshot = FlutterInappPurchase.purchaseError.listen((event) {
      Crashlytics.instance.log(event.message);
    });
  }

  @override
  void dispose() {
    if (purchaseSnapshot != null) purchaseSnapshot.cancel();
    if (errorPurchaseSnapshot != null) errorPurchaseSnapshot.cancel();
    instance.endConnection;
    super.dispose();
  }

  Future<void> _verifyPurchase(BuildContext context, PurchasedItem detail) async {
    VpnProvider vpnProvider = Provider.of<VpnProvider>(context, listen: false);
    DateTime purchaseTime = detail.transactionDate;

    switch (detail.productId.toLowerCase()) {
      case "one_week_subs":
        purchaseTime = purchaseTime.add(Duration(days: 7));
        break;
      case "one_month_subs":
        purchaseTime = purchaseTime.add(Duration(days: 30));
        break;
      case "one_year_subs":
        purchaseTime = purchaseTime.add(Duration(days: 365));
        break;
      case "three_days_subs":
        purchaseTime = purchaseTime.add(Duration(days: 3));
        break;
      default:
        Crashlytics.instance.log("Product ID not valid");
        return;
    }
    if (DateTime.now().isBefore(purchaseTime)) vpnProvider.proLimitDate = purchaseTime;
    try {
      await instance.finishTransaction(detail);
    } catch (e) {}
  }

  Future<List<IAPItem>> fetchProducts() async {
    var resp = await instance.getSubscriptions([
      "one_week_subs",
      "one_month_subs",
      "one_year_subs",
      "three_days_subs",
    ]);
    subscriptionProducts = resp;
    return resp;
  }

  Future<List<PurchasedItem>> getPastPurchase() async {
    var resp = await instance.getAvailablePurchases();
    return resp;
  }

  Future<PurchasedItem> hasPurchased(String id) async {
    return (await getPastPurchase())?.firstWhere((element) => element.productId == id, orElse: () => null);
  }

  Future subscribe(String id) async {
    await instance.requestSubscription(id);
  }
  
  Future refreshProStatus(BuildContext context) async {
    var resp = await instance.getPurchaseHistory();
    if (resp != null && resp.length > 0)
      resp.forEach((element) {
        _verifyPurchase(context, element);
      });
  }
}
