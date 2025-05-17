import 'package:flutter/material.dart';
import 'screens/register.dart';
import 'screens/login.dart';
import 'screens/home.dart';
import 'screens/maxpokemon.dart';
import 'screens/dashboard.dart';
import 'screens/search.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('userdata');
  runApp(MyApp());
}



class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:LoginScreen(),
    );
  }
}