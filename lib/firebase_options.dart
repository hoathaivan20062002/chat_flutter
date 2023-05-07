import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;

      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyCczVoRQ_mcYyZDN592Q9KLdtK7YZqWUdU',
  //   appId: '1:229838833305:web:5dfac56fcf13b7cf269a08',
  //   messagingSenderId: '229838833305',
  //   projectId: 'chatapps-fe4b4',
  //   authDomain: 'chatapps-fe4b4.firebaseapp.com',
  //   databaseURL: 'https://chatapps-fe4b4-default-rtdb.asia-southeast1.firebasedatabase.app',
  //   storageBucket: 'chatapps-fe4b4.appspot.com',
  //   measurementId: "G-5B4X9VLF61"
  // );

  // static const FirebaseOptions android = FirebaseOptions(
  //   apiKey: 'AIzaSyAoTB2BqZu_GsPoa3Z4gJJaCtzKb14Q90k',
  //   appId: '1:229838833305:android:c5649178489e4ab3269a08',
  //   messagingSenderId: '229838833305',
  //   projectId: 'chatapps-fe4b4',
  //   databaseURL: 'https://chatapps-fe4b4-default-rtdb.asia-southeast1.firebasedatabase.app',
  //   storageBucket: 'chatapps-fe4b4.appspot.com',
  // );
  static const FirebaseOptions web = FirebaseOptions(
      apiKey: 'AIzaSyCczVoRQ_mcYyZDN592Q9KLdtK7YZqWUdU',
      appId: '1:229838833305:web:5dfac56fcf13b7cf269a08',
      messagingSenderId: '647266404306',
      projectId: 'chat-flutter-99c3d',
      authDomain: 'chat-flutter-99c3d.firebaseapp.com',
      databaseURL:
          'https://chat-flutter-99c3d-default-rtdb.asia-southeast1.firebasedatabase.app',
      storageBucket: 'chat-flutter-99c3d.appspot.com',
      measurementId: "G-5B4X9VLF61");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDIk8N3yw9HmXS-tmsuDTPnl_bZ9lxuehY',
    appId: '1:647266404306:android:948f66a91919a80afaaa0b',
    messagingSenderId: '647266404306',
    projectId: 'chat-flutter-99c3d',
    databaseURL:
        'https://chat-flutter-99c3d-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'chat-flutter-99c3d.appspot.com',
  );
}
