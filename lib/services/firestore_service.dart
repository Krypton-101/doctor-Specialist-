import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference specialistsRef =
      FirebaseFirestore.instance.collection('specialists');

      final CollectionReference appointmentsRef =
      FirebaseFirestore.instance.collection('appointments');

  // 🔹 Add Specialist
  Future<void> addSpecialist(Map<String, dynamic> specialistData) async {
    try {
      await specialistsRef.add(specialistData);
    } catch (e) {
      throw Exception("Failed to add specialist: $e");
    }
  }

  // 🔹 Get Specialists
  Stream<QuerySnapshot> getSpecialists() {
    return specialistsRef.snapshots();
  }

  // 🔹 Get Specialist Details by ID
  Future<DocumentSnapshot> getSpecialistDetails(String id) async {
    return await specialistsRef.doc(id).get();
  }

  // 🔹 Update Specialist
  Future<void> updateSpecialist(String id, Map<String, dynamic> newData) async {
    try {
      await specialistsRef.doc(id).update(newData);
    } catch (e) {
      throw Exception("Failed to update specialist: $e");
    }
  }

  // 🔹 Delete Specialist
  Future<void> deleteSpecialist(String id) async {
    try {
      await specialistsRef.doc(id).delete();
    } catch (e) {
      throw Exception("Failed to delete specialist: $e");
    }
  }


  // Appointment Functions

   // 🔹 Fetch Appointments for a Specialist on a Specific Day
  Future<int> getNextAvailableAppointmentNumber(String specialistId, String date) async {
    QuerySnapshot snapshot = await appointmentsRef
        .where("specialistId", isEqualTo: specialistId)
        .where("date", isEqualTo: date)
        .get();

    int count = snapshot.docs.length;
    return count < 10 ? count + 1 : -1; // Return -1 if fully booked
  }

  // 🔹 Add Appointment
  Future<bool> addAppointment(Map<String, dynamic> appointmentData) async {
    try {
      await appointmentsRef.add(appointmentData);
      return true; // Success
    } catch (e) {
      return false; // Failure
    }
  }


}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:doctor_specialist/pages/Admin/add_specialist_failed.dart';
// import 'package:doctor_specialist/pages/Admin/add_specialist_successfully.dart';
// import 'package:flutter/material.dart';

// class FirestoreService {
//   final CollectionReference specialistsCollection =
//       FirebaseFirestore.instance.collection('specialists');

//   /** Fields in this category
//        * Full name
//        * Specialist Category
//        * Years of experience
//        * Availability
//        * From
//        * to
//        */
//   Future<void> addSpecialist(
//       String name,
//       String specialistCategory,
//       String experience,
//       List<String>
//           availableDays, // 🔥 Days available (e.g., ["Monday", "Wednesday"])
//       String fromTime, // 🔥 Start time
//       String toTime, // 🔥 End time
//       String roomNo,
//       BuildContext context) async {
//     try {
//       await specialistsCollection.add({
//         'name': name,
//         'specialistCategory': specialistCategory,
//         'experience': experience,
//         'availableDays': availableDays, // Store available days
//         'from': fromTime, // Store start time
//         'to': toTime, // Store end time
//         "roomNo": roomNo,
//         'createdAt': FieldValue.serverTimestamp(),
//       });

//       // 🔥 Navigate to Login Page after registration
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => AddSpecialistSuccessfully()),
//       );
//     } catch (e) {
//       print("Error adding specialist: $e");

//       // 🔥 Navigate to Login Page after registration
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => AddSpecialistFailed()),
//       );
//     }
//   }

//   // 🔹 Read Specialists
//   Stream<QuerySnapshot> getSpecialists() {
//     return specialistsCollection
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//   }

//   // 🔹 Update Specialist
//   Future<void> updateSpecialist(
//       String id, String name, String field, String experience) async {
//     await specialistsCollection.doc(id).update({
//       'name': name,
//       'field': field,
//       'experience': experience,
//     });
//   }

//   // 🔹 Delete Specialist
//   Future<void> deleteSpecialist(String id) async {
//     await specialistsCollection.doc(id).delete();
//   }
// }
