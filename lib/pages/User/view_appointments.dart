import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'appointment_details.dart';

class ViewAppointments extends StatefulWidget {
  const ViewAppointments({super.key});

  @override
  _ViewAppointmentsState createState() => _ViewAppointmentsState();
}

class _ViewAppointmentsState extends State<ViewAppointments> {
  String? currentUsername;

  @override
  void initState() {
    super.initState();
    _fetchUsername();
  }

  Future<void> _fetchUsername() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          currentUsername = userDoc['username'];
        });
      }
    }
  }

  String _formatDate(dynamic date) {
    if (date is Timestamp) {
      DateTime dateTime = date.toDate();
      return "${dateTime.day}-${dateTime.month}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}";
    } else if (date is String) {
      return date; // If already a string, return as is
    } else {
      return "Invalid Date"; // Handle unexpected cases
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Appointments')),
      body: currentUsername == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .where('username', isEqualTo: currentUsername)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Appointments Found'));
                }

                var appointments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var appointment =
                        appointments[index].data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(
                          'Appointment ${appointment['appointmentNumber']}'),
                      subtitle: Text(
                        '${appointment['specialistName']} - ${_formatDate(appointment['date'])}',
                      ),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
  var doc = appointments[index];   var appointment = doc.data() as Map<String, dynamic>;
  appointment['id'] = doc.id; 

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AppointmentDetails(appointment: appointment),
    ),
  );
},
                    );
                  },
                );
              },
            ),
    );
  }
}
