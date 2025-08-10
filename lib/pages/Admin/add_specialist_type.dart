import 'package:specialist2/pages/Admin/specialist_type_added_successfully.dart';
import 'package:flutter/material.dart';

class AddSpecialistType extends StatelessWidget {
  const AddSpecialistType({super.key});

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
                // Words
                Text(
                  "Add Specialist Type",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 50,
                ),

                  // Textfield 
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add),
                      labelText: 'Specialist Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                    ),
                  ),

                SizedBox(
                  height: 50,
                ),
            
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Add button
                    ElevatedButton(
                      onPressed: () {
                        // Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SpecialistTypeAddedSuccessfully()));
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
                        "Add",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 30,
                    ),


                    // Cancel btn
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BookSpecialist()));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}