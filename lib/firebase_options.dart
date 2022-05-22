// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCWkAVJXEoJFaSEg_UU7U3BN2YZ1XyGXac',
    appId: '1:159345288616:web:c2c6119726603fd07fe99d',
    messagingSenderId: '159345288616',
    projectId: 'flutterapp-86193',
    authDomain: 'flutterapp-86193.firebaseapp.com',
    storageBucket: 'flutterapp-86193.appspot.com',
    measurementId: 'G-1NWE4VPWDW',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCbeMsEjSgahNT9ZtDnlMMTJfTQ7zgMsNQ',
    appId: '1:159345288616:android:9b7ee5d9699581247fe99d',
    messagingSenderId: '159345288616',
    projectId: 'flutterapp-86193',
    storageBucket: 'flutterapp-86193.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDufAI8B0dmNzmjk5hKHuCs1nMUboeHSMM',
    appId: '1:159345288616:ios:cdd7d6ce8d09ae387fe99d',
    messagingSenderId: '159345288616',
    projectId: 'flutterapp-86193',
    storageBucket: 'flutterapp-86193.appspot.com',
    iosClientId: '159345288616-4pflm6sglaqst36hmnoeipio6nvog93e.apps.googleusercontent.com',
    iosBundleId: 'com.example.newFlutterApp',
  );
}
