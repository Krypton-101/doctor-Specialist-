import 'package:flutter/material.dart';   

class SpecialistInfo extends StatelessWidget {
  // Variables used in this class 
  final String name;
  final String specialistType;
  final int yearsOfExperience;
  
  const SpecialistInfo({
    super.key,
    required this.name,
    required this.specialistType,
    required this.yearsOfExperience
    });


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Specialist Name
          Text(name, 
          style: TextStyle(
            color: Colors.black, 
            fontSize: 20,
            fontWeight: FontWeight.bold
            ),
            ),

          // SizedBox(height: 5,),
          
          // Specialist Type
          Text("Cardiologist", 
          style: TextStyle(
            color: Colors.grey, 
            fontSize: 15,
            ),
            ),

          SizedBox(height: 10,),

          // Years of experience
          Text("$yearsOfExperience years of experience",
          style: TextStyle(
            color: Colors.grey, 
            fontSize: 15,
            ),
            ), 
        ],
      ),
    );
  }
}