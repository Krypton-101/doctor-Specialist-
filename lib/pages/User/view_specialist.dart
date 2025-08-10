import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/components/schedule_comp.dart';
import 'package:specialist2/components/specialist_info_comp.dart';
import 'package:specialist2/pages/User/book_appointment.dart';
import 'package:specialist2/services/auth_service.dart';
import 'package:specialist2/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ViewSpecialist extends StatefulWidget {
  final String specialistId;

  ViewSpecialist({required this.specialistId});

  @override
  State<ViewSpecialist> createState() => _ViewSpecialistState();
}

class _ViewSpecialistState extends State<ViewSpecialist> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();

  String? username;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  void _fetchUserInfo() async {
    Map<String, dynamic>? userDetails = await _authService.getCurrentUserDetails();

    if (userDetails != null) {
      setState(() {
        username = userDetails['username'];
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  // 🔹 Fetch average rating from Firestore
  Future<double?> _calculateAverageRating() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('specialistId', isEqualTo: widget.specialistId)
        .get();

    print("Retrieved ${snapshot.docs.length} documents for ratings");

    if (snapshot.docs.isEmpty) return null;

    double totalRating = 0;
    int count = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final rating = data['userRating'];

      print("Doc ID: ${doc.id}, Rating: $rating");

      if (rating != null && rating is num && rating > 0) {
        totalRating += rating.toDouble();
        count++;
      }
    }

    return count > 0 ? totalRating / count : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View Specialist")),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestoreService.getSpecialistDetails(widget.specialistId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text("Specialist not found"));
          }

          var specialist = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),

                // 🔹 Specialist Info
                SpecialistInfo(
                  name: specialist['name'],
                  specialistType: specialist['specialistCategory'],
                  yearsOfExperience: int.tryParse(specialist['experience'] ?? "0") ?? 0,
                ),

                SizedBox(height: 10),

                // 🔹 Average Rating
                FutureBuilder<double?>(
                  future: _calculateAverageRating(),
                  builder: (context, ratingSnapshot) {
                    if (ratingSnapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }

                    if (!ratingSnapshot.hasData || ratingSnapshot.data == null) {
                      return Text(
                        "No ratings yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      );
                    }

                    final average = ratingSnapshot.data!;
                    return Row(
                      children: [
                        RatingBarIndicator(
                          rating: average,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          itemCount: 5,
                          itemSize: 24.0,
                          direction: Axis.horizontal,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "${average.toStringAsFixed(1)} / 5.0",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ],
                    );
                  },
                ),

                SizedBox(height: 30),

                // 🔹 Schedule Title
                Text(
                  "Schedule",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),

                // 🔹 Schedule Details
                Container(
                  height: 150,
                  width: double.infinity,
                  child: ListView(
                    children: [
                      ScheduleComp(info: "Available:", data: specialist['availableDays'].join(', ')),
                      SizedBox(height: 10),
                      ScheduleComp(info: "From:", data: specialist['fromTime']),
                      SizedBox(height: 10),
                      ScheduleComp(info: "To:", data: specialist['toTime']),
                      SizedBox(height: 10),
                      ScheduleComp(info: "Room No:", data: specialist['roomNo']),
                    ],
                  ),
                ),

                SizedBox(height: 50),

                // 🔹 Book Now Button
                Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (username != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointment(
                              specialistId: widget.specialistId,
                              username: username!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Error: Username not found!")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text("Book Now", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
