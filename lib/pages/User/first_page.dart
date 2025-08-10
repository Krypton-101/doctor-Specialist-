import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/pages/User/book_specialist.dart';
import 'package:specialist2/pages/User/view_appointments.dart';
import 'package:specialist2/pages/User/view_appointments.dart'; // Import the new page
import 'package:specialist2/services/auth_service.dart';
import 'package:flutter/material.dart';

class Firstpage extends StatelessWidget {
  final String username;

  Firstpage({super.key, required this.username});

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
              onPressed: () async {
                await AuthService().signout(context: context);
              },
              icon: Icon(
                Icons.logout_rounded,
                size: 30,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 200),

            // Name and Greeting
            Container(
              height: 200,
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    "Hi, $username",
                    style: TextStyle(fontSize: 30, color: Colors.grey),
                  ),
                  Text(
                    "How are you feeling?",
                    style: TextStyle(fontSize: 30, color: Colors.blue),
                  ),
                ],
              ),
            ),

            // 🔹 Book Appointment Button
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BookSpecialist()),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Book Appointment", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),

            // 🔹 View Appointments Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ViewAppointments(), // Pass username
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("View Appointments", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
