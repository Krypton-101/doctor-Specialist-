import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/pages/User/view_specialist.dart';
import 'package:specialist2/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:specialist2/services/firestore_service.dart';
// import 'package:specialist2/services/firestore_services.dart';
import 'package:specialist2/services/auth_service.dart';
import 'book_appointment.dart';

class BookSpecialist extends StatelessWidget {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService(); // Initialize AuthService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Specialist"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _authService.signout(context: context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()), // Redirect to Login Page
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose a Specialist",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getSpecialists(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No specialists available"));
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      var specialist = doc.data() as Map<String, dynamic>;
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(specialist['name'], style: TextStyle(fontSize: 18)),
                          subtitle: Text(specialist['specialistCategory']),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewSpecialist(specialistId: doc.id),
                              ),
                            );
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
