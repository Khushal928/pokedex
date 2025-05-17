import 'package:flutter/material.dart';
import 'pokemonmini.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchcontroller = TextEditingController();
  MiniPokemon? pokemon;
  bool isLoading = false;
  bool hasSearched = false;

  void loadData(String name) async {
    setState(() {
      isLoading = true;
      hasSearched = true;
    });

    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      int id = data['id'];
      String imageUrl =
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
      List<String> type = [
        for (var t in data['types']) t['type']['name']
      ];

      setState(() {
        pokemon = MiniPokemon(
          name: data['name'],
          imageUrl: imageUrl,
          type: type,
        );
      });
    } else {
      setState(() {
        pokemon = null;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
        backgroundColor: Color(0xFF793D8E),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF793D8E), Color(0xFF453487)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: searchcontroller,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search Pokémon',
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
                  borderSide:
                      BorderSide(color: Colors.amberAccent, width: 2),
                ),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final name = searchcontroller.text.trim().toLowerCase();
                if (name.isNotEmpty) loadData(name);
              },
              child: Text("Search"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Center(
                child: () {
                  if (!hasSearched) return SizedBox(); 
                  if (isLoading) return CircularProgressIndicator();
                  if (pokemon == null) {
                    return Text("No result found",
                      style: TextStyle(color: Colors.white));
                  }
                  return pokemon;
                }(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
