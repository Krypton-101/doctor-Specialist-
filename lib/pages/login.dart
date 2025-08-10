import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:specialist2/pages/sign_in.dart';
import 'package:specialist2/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Auth service alias
  AuthService _authService = AuthService();

  // TextFields controller for login
  // Collects user data from textfields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 500,
              child: Column(
                children: [
                  // Login Text
                  Text(
                    "LOGIN",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      // color: Colors.green,
                      // color: Colors.white,
                    ),
                  ),
        
                  SizedBox(
                    height: 50,
                  ),
        
                  // Email
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
        
                  // Password
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        filled: true,
                      ),
                    ),
                  ),
        
                  SizedBox(
                    height: 20,
                  ),
        
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [Text("Forgot Password ?")],
                  //   ),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
        
                  // Login Button
                  ElevatedButton(
                      onPressed: () async {
                        await _authService.signin(
                          email: _emailController.text,
                          password: _passwordController.text,
                          context: context
                        );
        
                        // Clear text fields
                        // _emailController.text = "";
                        // _passwordController.text = "";
        
                      },
                      child: Text("Login",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(350, 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        // minimumSize: Size(2500, 40)
                      )),
        
                  SizedBox(
                    height: 20,
                  ),
        
        // If you dont have an account
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("You don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignIn()));
                        },
                        child: Text(
                          "Register Here",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
