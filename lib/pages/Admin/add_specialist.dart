import 'package:specialist2/pages/Admin/add_specialist_successfully.dart';
import 'package:specialist2/pages/Admin/add_specialist_failed.dart';
import 'package:specialist2/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSpecialist extends StatefulWidget {
  const AddSpecialist({super.key});

  @override
  State<AddSpecialist> createState() => _AddSpecialistState();
}

class _AddSpecialistState extends State<AddSpecialist> {
  // make this part same as the one in spacialist collection.add function
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController specialistCategoryController =
      TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();
  List<String> selectedDays = [];
  TimeOfDay? fromTime;
  TimeOfDay? toTime;

  // 🔹 Select Days
  void toggleDay(String day) {
    setState(() {
      selectedDays.contains(day)
          ? selectedDays.remove(day)
          : selectedDays.add(day);
    });
  }

  // 🔹 Pick Time
  Future<void> pickTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        isStartTime ? fromTime = pickedTime : toTime = pickedTime;
      });
    }
  }


void addSpecialist() async {
  // Checks the controller passed if its empty or not 
  if (nameController.text.isNotEmpty &&
      specialistCategoryController.text.isNotEmpty &&
      experienceController.text.isNotEmpty &&
      selectedDays.isNotEmpty &&
      fromTime != null &&
      toTime != null &&
      roomNoController.text.isNotEmpty) {


        // Passing Specialist data to Firestore using Map<String, dynamic> mapName
    Map<String, dynamic> specialistData = {
      'name': nameController.text.trim(),
      'specialistCategory': specialistCategoryController.text.trim(),
      'experience': experienceController.text.trim(),
      'availableDays': selectedDays,
      'fromTime': fromTime!.format(context),
      'toTime': toTime!.format(context),
      'roomNo': roomNoController.text.trim(),
    };

    try {
      await _firestoreService.addSpecialist(specialistData);
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpecialistSuccessfully()));
    } catch (e) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => AddSpecialistFailed()));
    }
  } else {
    Fluttertoast.showToast(
      msg: "All fields are required!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Specialist"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 10,
              ),

              // Fullname Textfield
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'FullName',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Text(
                "Specialist Category",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 10,
              ),

              // Specialist Textfield
              TextField(
                controller: specialistCategoryController,
                decoration: InputDecoration(
                  labelText: 'None',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Text(
                "Years of Experience",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              SizedBox(
                height: 10,
              ),

              // Experience Textfield
              TextField(
                controller: experienceController,
                decoration: InputDecoration(
                  labelText: 'None',
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                ),
              ),

              SizedBox(
                height: 20,
              ),

              // Days Available
              Text("Available Days:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: [
                  "Monday",
                  "Tuesday",
                  "Wednesday",
                  "Thursday",
                  "Friday",
                  "Saturday",
                  "Sunday"
                ]
                    .map((day) => ChoiceChip(
                          label: Text(day),
                          selected: selectedDays.contains(day),
                          onSelected: (_) => toggleDay(day),
                        ))
                    .toList(),
              ),

              SizedBox(
                height: 20,
              ),

// Room No
              TextField(
                controller: roomNoController,
                decoration: InputDecoration(
                  labelText: 'Room No',
                  border: OutlineInputBorder(
                    // borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  filled: true,
                ),
              ),

              // From, To, and Room No
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(true),
                      child: Text(fromTime == null
                          ? "Pick Start Time"
                          : "From: ${fromTime!.format(context)}"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => pickTime(false),
                      child: Text(toTime == null
                          ? "Pick End Time"
                          : "To: ${toTime!.format(context)}"),
                          
                    ),
                  ),
                  SizedBox(width: 10),
                ],
              ),

              SizedBox(
                height: 30,
              ),

              // Add Doctor button
              Center(
                child: ElevatedButton(
                    onPressed: addSpecialist,
                    child: Text("Add Specialist",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      // minimumSize: Size(2500, 40)
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
