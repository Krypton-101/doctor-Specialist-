import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:specialist2/pages/Admin/doctor_specialist.dart';
import 'package:specialist2/pages/User/first_page.dart';
import 'package:specialist2/pages/User/welcome_page.dart';
import 'package:specialist2/pages/login.dart';

class AuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// SignUp Method
// First user to sign up
  Future<void> signup({
    required String email,
    required String password,
    required String username,
    required BuildContext context, // Pass context for navigation
  }) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'uid': userCredential.user!.uid
      });

      // Show success message
      Fluttertoast.showToast(
        msg: "Registration Successful! Please log in.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14,
      );

      // 🔥 Navigate to Login Page after registration
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email';
      }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14,
      );

      
    } catch (e) {
      print("Error: $e");
    }
  }

// SignIn Method
// Make sure working
  Future<void> signin({
    required String email,
    required String password,
    required BuildContext context, // Pass context for navigation
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get user ID
      String uid = userCredential.user!.uid;     

      // Checks if user is Admin or not
      if (email.toLowerCase() == "admin@admin.com") {

        Fluttertoast.showToast(msg: "Welcome, Admin!");
        // 🔥 Navigate to Home Page & pass username
        // Error to consider here
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => DoctorSpecialist(username: "Admin")),
        );
      } else{
        // For normal user
         DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();
      String username = userDoc['username'];

      // Fluttertoast.showToast(msg: "Login Successful!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Firstpage(username: username)),
      );
      }

      

      // Show success message
      Fluttertoast.showToast(
        msg: "Login Successful!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 14,
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Authentication failed. Please try again.';

      switch (e.code) {
      case 'invalid-email':
        message = "Invalid email address.";
        break;
      case 'user-disabled':
        message = "This user has been disabled.";
        break;
      case 'user-not-found':
        message = "No account found for this email.";
        break;
      case 'wrong-password':
        message = "Incorrect password.";
        break;
      default:
        message = "Auth error: ${e.code}";
    }

      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14,
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  // Signout method
  Future<void> signout({required BuildContext context}) async {
    // method for signing out
    await _auth.signOut();
// creates  delay in a second
    await Future.delayed(const Duration(seconds: 1));
    
    // Pushes the page to the login page
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));

        Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => Login()), 
          (route) => false);
  }

  // Get Current User
  // 🔹 Get Current Logged-In User
  User? getCurrentUser() {
    return _auth.currentUser;
  }


  // 🔹 Get Current User Details from Firestore
  Future<Map<String, dynamic>?> getCurrentUserDetails() async {
    User? user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : null;
    }
    return null;
  }

  // Forgot Password function
  

}
