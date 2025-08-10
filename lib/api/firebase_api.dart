// import 'package:firebase_messaging/firebase_messaging.dart';

// class FirebaseApi{
//   // create an instance of FirebaseApi Messaging
//   final _firebaseMessaging = FirebaseMessaging.instance;

//   // function to initialize notifications
//   Future<void> initNotifications () async{
//     //  request permission from user
//     await _firebaseMessaging.requestPermission();

//     // Fetch the FCM token for this device
//     final FCMToken = await _firebaseMessaging.getToken();

//     //print the token()
//     print("Token: $FCMToken");
//   }

//   // function to handle received notifications
//   Future<void> handleNotifications(RemoteMessage? message) async {
//   //  If the message is null
//   if (message == null) return;

// // Navigate to new screen when message is received and user taps notification

//     // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//     //   // Handle the foreground notification
//     //   print("Received a message in the foreground: ${message.notification?.title}");
//     // });

//     // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     //   // Handle the notification when the app is opened from a background state
//     //   print("Notification opened: ${message.notification?.title}");
//     // });
//   } 
// }

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission(); // Ask for iOS permission
    FirebaseMessaging.onMessage.listen((message) {
      print("📩 FCM Message received: ${message.notification?.title}");
    });
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}
