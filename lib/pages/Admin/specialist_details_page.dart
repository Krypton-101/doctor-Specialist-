import 'package:flutter/material.dart';

class SpecialistDetailPage extends StatelessWidget {
  final String specialistType;

  SpecialistDetailPage({required this.specialistType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$specialistType Details")),
      body: Center(
        child: Text(
          "More information about $specialistType",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
