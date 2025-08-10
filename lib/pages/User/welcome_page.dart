import "package:specialist2/pages/login.dart";
import "package:specialist2/pages/sign_in.dart";
import "package:flutter/material.dart";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
      // Welcome part
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 400,
          width: 400,
          decoration: BoxDecoration(
              // color: Colors.blue,
              ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 60),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome
                Text(
                  "Welcome",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue),
                ),
                SizedBox(
                  height: 30,
                ),
      
                // Words
                Text(
                  "Welcome to Doctor Specialist, your go-to app for booking a specialist in your favorite hospital. When you need to set up an appointment, we've got you covered. Our app makes it easy to view and book appointments with just a few taps.",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
      
      // Get Started button
      SizedBox(
        width: double.infinity, // Full-width button
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.blue),
            foregroundColor: MaterialStatePropertyAll<Color>(Colors.white),
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Login())
                );
          },
          child: Text('Log In',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
              ],
            ),
    );
  }
}
