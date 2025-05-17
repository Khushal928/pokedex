import 'package:flutter/material.dart';
import 'dart:convert';
import 'home.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';



class LoginScreen extends StatelessWidget {
  final usernamecontroller = TextEditingController();
  final passwordcontroller = TextEditingController();


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
            mainAxisAlignment: MainAxisAlignment.center,          
            children :[
            Text("Login"
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
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  loginuser(usernamecontroller.text, passwordcontroller.text, context);
                },
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            )
          ])
        ),
      ),
    );
  }

  void loginuser(String username, String password, BuildContext context) async{
    final url = Uri.parse('http://192.168.13.148:5000/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print('login successfull:${responseData['message']}');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyWidget(),
          
        ),
      );
      print("somethig is done");
      var box = Hive.box('userdata');
      box.put('username', username);

    } else {
      print('login failed:${response.statusCode}');
    }
  }
}