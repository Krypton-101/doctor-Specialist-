import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/services/firestore_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SpecialistDetails extends StatefulWidget {
  final String specialistId;

  SpecialistDetails({required this.specialistId});

  @override
  _SpecialistDetailsState createState() => _SpecialistDetailsState();
}

class _SpecialistDetailsState extends State<SpecialistDetails> {
  // Initializing instances
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, dynamic>? specialistData;
  bool isLoading = true;

// Controller initialization
  final TextEditingController nameController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  List<String> selectedDays = [];
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  @override
  void initState() {
    super.initState();
    _fetchSpecialistDetails();
  }

  // 🔹 Fetch Specialist Details
  void _fetchSpecialistDetails() async {
    try {
      DocumentSnapshot doc = await _firestoreService.getSpecialistDetails(widget.specialistId);
      if (doc.exists) {
        setState(() {
          specialistData = doc.data() as Map<String, dynamic>;

          // Populate fields
          nameController.text = specialistData!['name'];
          categoryController.text = specialistData!['specialistCategory'];
          experienceController.text = specialistData!['experience'];
          roomNoController.text = specialistData!['roomNo'];
          selectedDays = List<String>.from(specialistData!['availableDays']);
          fromTime = _convertToTimeOfDay(specialistData!['fromTime']);
          toTime = _convertToTimeOfDay(specialistData!['toTime']);

          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching specialist details: $e");
    }
  }

  // 🔹 Convert Time String to TimeOfDay
  TimeOfDay _convertToTimeOfDay(String time) {
    final parts = time.split(":");
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  // 🔹 Update Specialist
  void _updateSpecialist() async {
    if (nameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        experienceController.text.isEmpty ||
        roomNoController.text.isEmpty ||
        selectedDays.isEmpty ||
        fromTime == null ||
        toTime == null) {
      Fluttertoast.showToast(
        msg: "All fields are required!",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    Map<String, dynamic> updatedData = {
      'name': nameController.text.trim(),
      'specialistCategory': categoryController.text.trim(),
      'experience': experienceController.text.trim(),
      'roomNo': roomNoController.text.trim(),
      'availableDays': selectedDays,
      'fromTime': "${fromTime!.hour}:${fromTime!.minute}",
      'toTime': "${toTime!.hour}:${toTime!.minute}",
    };

    try {
      await _firestoreService.updateSpecialist(widget.specialistId, updatedData);
      Fluttertoast.showToast(msg: "Specialist updated successfully!", backgroundColor: Colors.green);
      Navigator.pop(context); // Go back after updating
    } catch (e) {
      Fluttertoast.showToast(msg: "Update failed!", backgroundColor: Colors.red);
    }
  }

  // 🔹 Delete Specialist
  void _deleteSpecialist() async {
    try {
      await _firestoreService.deleteSpecialist(widget.specialistId);
      Fluttertoast.showToast(msg: "Specialist deleted!", backgroundColor: Colors.green);
      Navigator.pop(context); // Go back after deletion
    } catch (e) {
      Fluttertoast.showToast(msg: "Deletion failed!", backgroundColor: Colors.red);
    }
  }

  // 🔹 Toggle Day Selection
  void toggleDay(String day) {
    setState(() {
      selectedDays.contains(day) ? selectedDays.remove(day) : selectedDays.add(day);
    });
  }

  // 🔹 Pick Time
  Future<void> pickTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (pickedTime != null) {
      setState(() {
        isStartTime ? fromTime = pickedTime : toTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Specialist Details")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : specialistData == null
              ? Center(child: Text("Specialist not found"))
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextField(controller: nameController, decoration: InputDecoration(border: OutlineInputBorder())),

                        SizedBox(height: 10),
                        Text("Specialist Category", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextField(controller: categoryController, decoration: InputDecoration(border: OutlineInputBorder())),

                        SizedBox(height: 10),
                        Text("Years of Experience", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextField(controller: experienceController, decoration: InputDecoration(border: OutlineInputBorder())),

                        SizedBox(height: 10),
                        Text("Room No", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        TextField(controller: roomNoController, decoration: InputDecoration(border: OutlineInputBorder())),

                        SizedBox(height: 10),
                        Text("Available Days", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Wrap(
                          spacing: 8,
                          children: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
                              .map((day) => ChoiceChip(
                                    label: Text(day),
                                    selected: selectedDays.contains(day),
                                    onSelected: (_) => toggleDay(day),
                                  ))
                              .toList(),
                        ),

                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => pickTime(true),
                                child: Text(fromTime == null ? "Pick Start Time" : "From: ${fromTime!.format(context)}"),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => pickTime(false),
                                child: Text(toTime == null ? "Pick End Time" : "To: ${toTime!.format(context)}"),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _updateSpecialist,
                                child: Text("Update"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _deleteSpecialist,
                                child: Text("Delete"),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
