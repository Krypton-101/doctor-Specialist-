import 'package:flutter/material.dart';

class ScheduleComp extends StatelessWidget {
  final String info;
  final String data;

  const ScheduleComp({
    super.key,
    required this.info,
    required this.data
    });

  @override
  Widget build(BuildContext context) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // left text 
        Text(
          info,
          style: TextStyle(
            color: Colors.black, 
            fontSize: 15,
            ),
            ),

            // right text
            Text(
              data,
              style: TextStyle(
                color: Colors.grey, 
                fontSize: 15,
                ),
                ),
      ],
    );
  }
}