import 'package:specialist2/pages/User/book_specialist.dart';
import 'package:specialist2/pages/User/first_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:specialist2/services/firestore_service.dart';
import 'package:specialist2/pages/User/first_page.dart';

class BookAppointment extends StatefulWidget {
  final String specialistId;
  final String username;

  BookAppointment({required this.specialistId, required this.username});

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  final FirestoreService _firestoreService = FirestoreService();
  
  TextEditingController _dateController = TextEditingController();

  String? specialistName;
  String? specialistCategory;
  String? roomNo;
  List<String> availableDays = [];
  int? appointmentNumber;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSpecialistDetails();
  }

  // 🔹 Fetch Specialist Details
  void _fetchSpecialistDetails() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('specialists')
          .doc(widget.specialistId)
          .get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;

        setState(() {
          specialistName = data['name'];
          specialistCategory = data['specialistCategory'];
          roomNo = data['roomNo'];
          availableDays = List<String>.from(data['availableDays']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching specialist details: $e");
      setState(() => isLoading = false);
    }
  }

  // 🔹 Select Date (Only Available Days)
  void _selectDate(BuildContext context) async {
  DateTime now = DateTime.now();
  DateTime initialDate = now;

  // 🔹 Ensure initialDate is an available day
  while (!availableDays.contains(_getDayOfWeek(initialDate.weekday))) {
    initialDate = initialDate.add(Duration(days: 1)); // Move to next day
  }

  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate, // Set initial date to an available day
    firstDate: now,
    lastDate: DateTime(now.year, 12, 31),
    selectableDayPredicate: (DateTime date) {
      return availableDays.contains(_getDayOfWeek(date.weekday));
    },
  );

  if (picked != null) {
    setState(() {
      _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      _checkAvailableSlots();
    });
  }
}

  // 🔹 Get Day Name from Weekday Number
  String _getDayOfWeek(int day) {
    return ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"][day - 1];
  }

  // 🔹 Check Available Slots
  void _checkAvailableSlots() async {
    if (_dateController.text.isNotEmpty) {
      int slot = await _firestoreService.getNextAvailableAppointmentNumber(widget.specialistId, _dateController.text);
      setState(() {
        appointmentNumber = slot;
      });

      if (slot == -1) {
        _showFullyBookedDialog();
      }
    }
  }



  // 🔹 Confirm Appointment Popup
  void _showConfirmationDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // Rounded corners for modern look
      ),
      title: Center(
        child: Text(
          "Confirm Appointment",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),

          // 🔹 Specialist Info
          Row(
            children: [
              Text("👨‍⚕️ Specialist: ", style: _infoTitleStyle),
              Text(specialistName ?? "Loading...", style: _infoValueStyle),
            ],
          ),

          SizedBox(height: 10),

          // 🔹 Specialist Category
          Row(
            children: [
              Text("🏥 Category: ", style: _infoTitleStyle),
              Text(specialistCategory ?? "N/A", style: _infoValueStyle),
            ],
          ),

          SizedBox(height: 10),

          // 🔹 Selected Date
          Row(
            children: [
              Text("📅 Date: ", style: _infoTitleStyle),
              Text(_dateController.text, style: _infoValueStyle),
            ],
          ),

          SizedBox(height: 10),


          // 🔹 Room Number
          Row(
            children: [
              Text("🚪 Room No: ", style: _infoTitleStyle),
              Text(roomNo ?? "N/A", style: _infoValueStyle),
            ],
          ),

          SizedBox(height: 20),
          
          // 🔹 Appointment Number
          Row(
            children: [
              Text("📌 Appointment No: ", style: _infoTitleStyle),
              Text(appointmentNumber != null ? appointmentNumber.toString() : "N/A", style: _infoValueStyle),
            ],
          ),

          SizedBox(height: 20),
        ],
      ),
      actions: [
        // 🔹 Cancel Button
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(fontSize: 16, color: Colors.red)),
        ),

        // 🔹 Confirm Button
        ElevatedButton(
          onPressed: _submitAppointment,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text("Confirm", style: TextStyle(fontSize: 16, color: Colors.white)),
        ),
      ],
    ),
  );
}

// 🔹 Custom Styles for Better Readability
final TextStyle _infoTitleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[800]);
final TextStyle _infoValueStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);


  void _submitAppointment() async {
  Navigator.pop(context); // Close the confirmation dialog

  if (appointmentNumber == null || appointmentNumber == -1) {
    _showErrorDialog("No slots available. Please choose another day.");
    return;
  }

// look on this 
  QuerySnapshot existingAppointments = await FirebaseFirestore.instance
      .collection('appointments')
      .where('username', isEqualTo: widget.username)
      .where('specialistId', isEqualTo: widget.specialistId)
      .where('date', isEqualTo: _dateController.text) // Check for duplicate
      .get();

  if (existingAppointments.docs.isNotEmpty) {
    _showErrorDialog("You have already booked an appointment with this specialist on this date.");
    return;
  }

  // 🔹 Convert date string to a Firestore Timestamp
  DateTime selectedDate = _convertStringToDate(_dateController.text);

// Removed the time variable
  Map<String, dynamic> appointmentData = {
    'specialistId': widget.specialistId,
    'specialistName': specialistName,
    'specialistCategory': specialistCategory,
    'roomNo': roomNo,
    'date': Timestamp.fromDate(selectedDate), // Store as Firestore Timestamp
    'username': widget.username,
    'appointmentNumber': appointmentNumber,
  };

  bool success = await _firestoreService.addAppointment(appointmentData);

  if (success) {
    _showSuccessDialog();
  } else {
    _showErrorDialog("Appointment not successfully sent.");
  }
}

// 🔹 Convert date string ("18-03-2025") to DateTime
DateTime _convertStringToDate(String dateString) {
  List<String> parts = dateString.split("-");
  return DateTime(int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
}


  // 🔹 Show Success Dialog
  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text("Appointment successfully sent."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (context) => Firstpage(username: widget.username,)), 
          (route) => false),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // 🔹 Show Error Dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // 🔹 Show Fully Booked Dialog
  void _showFullyBookedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Fully Booked"),
        content: Text("This specialist is fully booked for the selected day. Please choose another day."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book Appointment")),
      body: isLoading ? Center(child: CircularProgressIndicator()) : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Title
          Text(
            "Schedule Doctor's Appointment",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 20),

          // 🔹 Specialist Name
          Text(
            specialistName ?? "Loading...",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            specialistCategory ?? "",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          SizedBox(height: 20),

          // 🔹 Room Number
          Text("Room No: ${roomNo ?? "N/A"}", style: TextStyle(fontSize: 16)),

          SizedBox(height: 30),

          // 🔹 Date Picker
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              labelText: "Select Date",
              hintText: "Choose an available date",
              suffixIcon: Icon(Icons.calendar_today),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.grey[200],
            ),
          ),

          SizedBox(height: 20),

          

          // 🔹 Proceed Button
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_dateController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please select date of the appointment")),
                  );
                  return;
                }
                _showConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Proceed", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

}


