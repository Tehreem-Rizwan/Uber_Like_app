// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return macos;
      case TargetPlatform.windows:
        return windows;
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
    apiKey: 'AIzaSyDTa8viFC23a6NTzL-bhUEGVad1OmFwQMg',
    appId: '1:517194880909:web:13ebc4decd640802094fc4',
    messagingSenderId: '517194880909',
    projectId: 'wsecure20',
    authDomain: 'w20.firebaseapp.com',
    storageBucket: 'wsecure20.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBJsk7XbGZ4mkqTIHUMN-H3w2oByNdLc-U',
    appId: '1:517194880909:android:0c10e0748e2132dc094fc4',
    messagingSenderId: '517194880909',
    projectId: 'wsecure20',
    storageBucket: 'wsecure20.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA9r-jR2wwWkKwihuBaD9ernvG9ode_rm4',
    appId: '1:517194880909:ios:1a9e220bc4c70e80094fc4',
    messagingSenderId: '517194880909',
    projectId: 'wsecure20',
    storageBucket: 'wsecure20.appspot.com',
    iosBundleId: 'com.example.uberLikeApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA9r-jR2wwWkKwihuBaD9ernvG9ode_rm4',
    appId: '1:517194880909:ios:1a9e220bc4c70e80094fc4',
    messagingSenderId: '517194880909',
    projectId: 'wsecure20',
    storageBucket: 'wsecure20.appspot.com',
    iosBundleId: 'com.example.uberLikeApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDTa8viFC23a6NTzL-bhUEGVad1OmFwQMg',
    appId: '1:517194880909:web:d3137688ae08029d094fc4',
    messagingSenderId: '517194880909',
    projectId: 'wsecure20',
    authDomain: 'w20.firebaseapp.com',
    storageBucket: 'wsecure20.appspot.com',
  );
}
