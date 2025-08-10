import 'package:specialist2/pages/Admin/doctor_specialist.dart';
import 'package:flutter/material.dart';

class AddSpecialistFailed extends StatelessWidget {
  const AddSpecialistFailed({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 320,
          width: 350,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Icon
                Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 120,
                ),

                SizedBox(
                  height: 20,
                ),
            
                // Words
                Center(
                  child: Text(
                    "Specialist Add Failed",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  height: 50,
                ),
            
                // Button
                ElevatedButton(
                  onPressed: () {
                    // Navigator.pop(context);
                    Navigator.push (context, MaterialPageRoute(builder: (context) => DoctorSpecialist(username: 'username',)));
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