import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

class FirebaseConfig {
  static FirebaseApp? app;

  static Future<void> init() async {
    app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // storage = FirebaseStorage.instance;
  }
}
