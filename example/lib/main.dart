import 'package:example/context_example.dart';
import 'package:raccoon/raccoon.dart';

void main() {
  // runApp(MyApp());

  Raccoon(RaccoonApp(
    // home: StateExample(),
    // home: CatcherExample(),
    // home: FirebaseExample(),
    // isDevicePreviewOn: true,
    routes: [RaccoonRoute(name: '/', builder: (setting, context) => ContextExample())],
  ));
}
