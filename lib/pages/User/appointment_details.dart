import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmentDetails extends StatefulWidget {
  final Map<String, dynamic> appointment;

  const AppointmentDetails({super.key, required this.appointment});

  @override
  State<AppointmentDetails> createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  String status = "Loading...";
  Color statusColor = Colors.grey;
  double? userRating;
  late String appointmentId;

  @override
  void initState() {
    super.initState();
    appointmentId = widget.appointment['id'] ?? '';
    determineStatus();
    userRating = widget.appointment['userRating'];
  }

  String getFormattedDate() {
    var appointmentDate = widget.appointment['date'];
    if (appointmentDate is Timestamp) {
      DateTime dateTime = appointmentDate.toDate();
      return DateFormat('dd MMMM yyyy').format(dateTime);
    } else if (appointmentDate is String) {
      try {
        DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(appointmentDate);
        return DateFormat('dd MMMM yyyy').format(parsedDate);
      } catch (e) {
        print("Date parsing error: $e");
        return "Invalid Date";
      }
    } else {
      return "Invalid Date";
    }
  }

  Future<void> determineStatus() async {
    Timestamp dateTimestamp = widget.appointment['date'];
    DateTime appointmentDate = dateTimestamp.toDate();
    DateTime now = DateTime.now();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime appointmentOnlyDate = DateTime(
      appointmentDate.year,
      appointmentDate.month,
      appointmentDate.day,
    );

    Duration diff = appointmentOnlyDate.difference(today);

    String newStatus;
    Color newColor;

    if (diff.inDays < 0) {
      newStatus = "Completed";
      newColor = Colors.red;
    } else if (diff.inDays <= 2) {
      newStatus = "Due Soon";
      newColor = Colors.orange;
    } else {
      newStatus = "Upcoming";
      newColor = Colors.green;
    }

    setState(() {
      status = newStatus;
      statusColor = newColor;
    });
  }

  void showRatingDialog() {
    double rating = 3.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Rate Specialist'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Rating: ${rating.toStringAsFixed(1)}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Slider(
                    value: rating,
                    min: 1.0,
                    max: 5.0,
                    divisions: 8,
                    label: rating.toStringAsFixed(1),
                    onChanged: (newRating) {
                      setStateDialog(() {
                        rating = newRating;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (appointmentId.isNotEmpty) {
                      // Save the rating
                      await FirebaseFirestore.instance
                          .collection('appointments')
                          .doc(appointmentId)
                          .update({'userRating': rating});

                      // Re-fetch updated appointment document
                      final updatedDoc = await FirebaseFirestore.instance
                          .collection('appointments')
                          .doc(appointmentId)
                          .get();

                      setState(() {
                        userRating = updatedDoc['userRating'];
                      });
                    } else {
                      print("Error: appointment ID is missing");
                    }

                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = getFormattedDate();

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment ${widget.appointment['appointmentNumber']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Status Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Appointment Info
            Text('Specialist: ${widget.appointment['specialistName']}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Category: ${widget.appointment['specialistCategory']}'),
            Text('Date: $formattedDate'),
            Text('Room No: ${widget.appointment['roomNo']}'),
            Text('Appointment No: ${widget.appointment['appointmentNumber']}'),
            const SizedBox(height: 30),

            // Rating Section
            if (status == "Completed")
              userRating == null
                  ? Center(
                      child: ElevatedButton.icon(
                        onPressed: showRatingDialog,
                        icon: const Icon(Icons.star),
                        label: const Text("Rate Specialist"),
                      ),
                    )
                  : Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.amber, size: 30),
                        const SizedBox(width: 8),
                        Text(
                          "You rated: ${userRating!.toStringAsFixed(1)}",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
          ],
        ),
      ),
    );
  }
}
