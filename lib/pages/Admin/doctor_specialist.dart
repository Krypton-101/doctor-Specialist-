import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/pages/Admin/add_specialist.dart';
import 'package:specialist2/pages/Admin/specialist_details.dart';
import 'package:specialist2/pages/Admin/specialist_details_page.dart';
import 'package:specialist2/services/auth_service.dart';
import 'package:flutter/material.dart';

class DoctorSpecialist extends StatefulWidget {
  final String username;

  DoctorSpecialist({Key? key, required this.username}) : super(key: key);

  @override
  _DoctorSpecialistState createState() => _DoctorSpecialistState();
}

class _DoctorSpecialistState extends State<DoctorSpecialist> {
  final AuthService _authService = AuthService();
  String fullname = "Loading...";
  final CollectionReference specialistsRef =
      FirebaseFirestore.instance.collection('specialists');

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  // 🔹 Fetch Username from Firestore
  void _fetchUserName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.username)
          .get();

      setState(() {
        fullname = userDoc["username"]; // Fetch username
      });
    } catch (e) {
      setState(() {
        fullname = "User";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Doctor Specialist $fullname"),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: Column(
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  Text(
                    "Doctor Specialist",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Admin",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text("Add Specialist"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpecialist()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Log Out"),
              onTap: () async {
                await _authService.signout(context: context);
              },
            ),
          ],
        ),
      ),
      // 🔹 View Specialist List
      body: StreamBuilder<QuerySnapshot>(
        stream: specialistsRef.snapshots(),
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

              return ListTile(
                title: Text(specialist['name']),
                subtitle: Text(specialist['specialistCategory']),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SpecialistDetails(specialistId: doc.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
