import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemonmini.dart';
import 'package:hive_flutter/hive_flutter.dart';


class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<int> pokemon = [];
  List<MiniPokemon> pokemonsmini = [];
  String username = '';


  @override
  void initState() {
    super.initState();
    username = Hive.box('userdata').get('username', defaultValue: '');
    getpokemonids(username);
  }

  void getpokemonids(String username) async {
    final url = Uri.parse('http://192.168.13.148:5000/dashboard');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final pokemonids = responseData["pokemon ids"];
        setState(() {
          pokemon = pokemonids;
        });
        getpokemondetails();
        print('Pokemon IDs: $pokemonids');
        print(pokemonids);
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to connect: $e");
    }
  }
  void getpokemondetails() async {
    for (int id in pokemon) {
      final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final name = data['name'];
        final imageUrl = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png";

        List<String> types = [];
        for (var typeInfo in data['types']) {
          types.add(typeInfo['type']['name']);
        }

        setState(() {
          pokemonsmini.add(MiniPokemon(
            name: name,
            imageUrl: imageUrl,
            type: types,
          ));
        });
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Dashboard",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF793D8E),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              if (pokemonsmini.isEmpty) {
                return Center(child: CircularProgressIndicator());
              } else {
                return GridView.count(
                  crossAxisCount: 2, 

                  childAspectRatio: 3 / 3.5, 
                  children: pokemonsmini,
                );

              }
            },
          ),
        ),
      ),
    );
  }
}
