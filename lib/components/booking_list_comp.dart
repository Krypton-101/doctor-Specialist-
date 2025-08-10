import 'package:flutter/material.dart';


class Bookinglist extends StatelessWidget {
  // Variables used in the Bookinglist class
  final String specialistName;
  final String specialistType;

  const Bookinglist({
  super.key, 
  required this.specialistName,
  required this.specialistType
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          // Specialist Name  
              Text(
                specialistName, 
                style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                ),
                ),

          // Specialist Type  
          Text(
            specialistType, 
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey
              ),
          ),
            ],
          ),

          // Book button
          Container(
            height: 40,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(
                color: Colors.blue, 
                width: 1,
                ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                "View", 
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  ),
                  )),
          )
        ],
      ),
    );
  }
}