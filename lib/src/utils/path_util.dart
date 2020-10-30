import 'package:path_provider/path_provider.dart';

class PathUtil {
  PathUtil._();

  static Future<String> appPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  static Future<String> tempPath() async {
    return (await getTemporaryDirectory()).path;
  }
}
