import 'package:firebase_core/firebase_core.dart';

class FirebaseConfig {
  static const FirebaseOptions web = FirebaseOptions(
    apiKey:
        'AIzaSyB1-3k5r1O9zgLRLqefY-w6ejSNGNkPHRc', // You'll need to get this from Firebase Console
    authDomain: 'feature-flags.firebaseapp.com',
    databaseURL: 'https://feature-flags.firebaseio.com/',
    projectId: 'feature-flags',
    storageBucket: 'feature-flags.appspot.com',
    messagingSenderId: '239733814657',
    appId: '1:239733814657:android:617a201d6d6a96451ea480',
  );
}

class FirebaseConfigOptions {
  static FirebaseOptions get currentPlatform {
    return FirebaseConfig.web;
  }
}
