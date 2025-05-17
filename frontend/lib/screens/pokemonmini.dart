import 'package:flutter/material.dart';import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'maxpokemon.dart';

class MiniPokemon extends StatelessWidget{

  final Map<String, Color> typeColors = {
  'fire': Colors.red,
  'water': Colors.blue,
  'grass': Colors.green,
  'electric': Colors.yellow,
  'psychic': Colors.purple,
  'rock': Colors.brown,
  'ground': Colors.orange,
  'bug': Colors.lightGreen,
  'fairy': Colors.pink,
  'normal': Colors.grey,
  'fighting': Colors.deepOrange,
  'ghost': Colors.indigo,
  'dragon': Colors.indigoAccent,
  'ice': Colors.cyan,
  'poison': Colors.deepPurple,
  'dark': Colors.black,
  'steel': Colors.blueGrey,
  'flying': Colors.lightBlue,
};

  final String name;
  final String imageUrl;
  final List<String> type;

  MiniPokemon({
    required this.name,
    required this.imageUrl,
    required this.type,
  });

  String getName() {
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: typeColors[type[0]] ?? Colors.grey,
      ),
      margin: EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Maxpokemon(name: name),
            ),
          );
        },
        child: Column(
          children: [
            Text(name),
            Image.network(imageUrl),
            Text(type[0]),
            if (type.length > 1) Text(type[1]),
          ],
        ),
      ),
    );
  }
}