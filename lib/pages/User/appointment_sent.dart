import 'package:specialist2/pages/User/book_specialist.dart';
import 'package:specialist2/pages/User/welcome_page.dart';
import 'package:flutter/material.dart'; 

class AppointmentSent extends StatelessWidget {
  const AppointmentSent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 300,
          width: 300,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 214, 214, 214),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                // Icon
                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 120,
                ),

                SizedBox(
                  height: 20,
                ),
            
                // Words
                Text(
                  "Appointment Sent",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),
            
                // Button
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookSpecialist()));
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  child: Text(
                    "Confirm",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}