
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:specialist2/api/firebase_api.dart';
import 'package:specialist2/firebase_options.dart';
import 'package:specialist2/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseApi().initNotifications();
  await saveFcmToken(); 

  runApp(const MyApp());
}

Future<void> saveFcmToken() async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user logged in yet, FCM token will be saved after login.");
      return;
    }

    final token = await FirebaseApi().getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'fcmToken': token}, SetOptions(merge: true));
      print("✅ Token saved to Firestore: $token");
    }
  } catch (e) {
    print("❌ Error saving FCM token: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
