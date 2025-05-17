import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert'; // for jsonEncode

class RegisterScreen extends StatelessWidget {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();
  final confirmpasswordcontroller = TextEditingController();
  final gmailcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          color: Colors.white,
        )),
          backgroundColor: Color(0xFF793D8E),
          centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF793D8E),
              Color(0xFF453487),
            ],
          ),
        ),
        child: 
        Container(
          padding: const EdgeInsets.all(40.0),
          
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,              // Center the content vertically
            children :[
            Text("Register"
            , style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.white,
              fontSize: 24,
            )),

            Container(
              margin: EdgeInsets.only(left: 10, top: 50),
              child: TextField(
                controller : usernamecontroller,
                decoration: InputDecoration(labelText: 'Username',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: TextField(
                controller : passwordcontroller,
                decoration: InputDecoration(labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              )
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: TextField(
                controller : confirmpasswordcontroller,
                decoration: InputDecoration(labelText: 'confirm Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              )
            ),

            Container(
              margin: EdgeInsets.only(left: 10, top: 20),
              child: TextField(
                controller : gmailcontroller,
                decoration: InputDecoration(labelText: 'gmail',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white),
                  ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.amberAccent, width: 2),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              )
            ),

 
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  registeruser(usernamecontroller.text, passwordcontroller.text, confirmpasswordcontroller.text, gmailcontroller.text);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text('Register'),

              ),
            )
          ])
        ),
      ),
    );
  }

  void registeruser(String username, String password, String confirmpassword, String gmail) async{
    final url = Uri.parse('http://10.0.2.2:5000/register');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'confirmpassword': confirmpassword,
        'gmail': gmail,
      }),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      print('registration successfull:${responseData['message']}');
    } else {
      final responseData = jsonDecode(response.body);
      print('registration failed:${responseData['error']} errorcode:${response.statusCode}');
    }
  }
}