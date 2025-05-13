import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyAOWKZ2EpE7Zd_1UKGGUq47VY0D28QteCE',
      appId: '1:563389738670:android:77fbc19421851b118ac73f',
      messagingSenderId: '246137444053',
      projectId: 'prontuario-1866d',
      storageBucket: 'prontuario-b0e08.firebasestorage.app',
    );
  }
}
