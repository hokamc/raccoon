import 'dart:async';

import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:raccoon/raccoon.dart';

class PurchaseUtil {
  PurchaseUtil._();

  static void init({String apiKey = 'api_key', String userId}) {
    Purchases.setDebugLogsEnabled(false);
    Purchases.setup(apiKey, appUserId: userId);
    Purchases.collectDeviceIdentifiers();
  }

  static Future<List<String>> subscriptions() async {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    return purchaserInfo.activeSubscriptions;
  }

  static Future<List<String>> products() async {
    PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
    return purchaserInfo.nonSubscriptionTransactions.map((transaction) => transaction.productId).toList();
  }

  static Future<List<Package>> offerings() async {
    Offerings offerings = await Purchases.getOfferings();
    return offerings.current == null ? [] : offerings.current.availablePackages;
  }

  static Future<PurchaserInfo> purchase(Package package) async {
    LOG.event('purchase_${package.identifier}');
    return await Purchases.purchasePackage(package);
  }
}
