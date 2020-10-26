import 'dart:io';

class NetworkUtil {
  static Future<bool> isInternetConnectionAvailable() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (exception) {
      return Future.value(false);
    }
  }
}