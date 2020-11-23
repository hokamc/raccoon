import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class PathUtil {
  PathUtil._();

  static Future<String> appPath() async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  static Future<String> tempPath() async {
    return (await getTemporaryDirectory()).path;
  }

  static String join(String part1, [String part2, String part3, String part4, String part5, String part6, String part7, String part8]) {
    return path.join(part1, part2, part3, part4, part5, part6, part7, part8);
  }
}
