import 'dart:io';

class NetworkUtil {
  NetworkUtil._();

  static Future<bool> hasInternet() async {
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
