import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'pokemonmini.dart';
import 'search.dart';
import 'dashboard.dart';

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  int index = 0;

  List<MiniPokemon> pokemonsmini = [];

  void initState() {
    super.initState();
    getinfo();
  }

  void getinfo() async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=50&offset=0');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        List<MiniPokemon> loadedPokemons = []; 

        for (var item in data['results']) {
          var name = item['name'];
          var url = item['url'];
          var id = url.split('/')[6];
          var imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
          List<String> type = [];

          var evolutionUrl = 'https://pokeapi.co/api/v2/pokemon-species/$id';
          var evolutionResponse = await http.get(Uri.parse(evolutionUrl));
          var evolutionData;
          if (evolutionResponse.statusCode == 200) {
            evolutionData = jsonDecode(evolutionResponse.body);
          } else {
            print('Error fetching evolution chain: ${evolutionResponse.statusCode}');
          }
          var evolutionChainUrl = evolutionData['evolution_chain']['url'];
          var evolutionChainResponse = await http.get(Uri.parse(evolutionChainUrl));
          var evolutionChainData;
          if (evolutionChainResponse.statusCode == 200) {
            evolutionChainData = jsonDecode(evolutionChainResponse.body);
          } else {
            print('Error fetching evolution chain: ${evolutionChainResponse.statusCode}');
          }
          var evolutionName = evolutionChainData['chain']['species']['name'];

          if(name == evolutionName){
            var typeUrl = 'https://pokeapi.co/api/v2/pokemon/$id';
            var typeResponse = await http.get(Uri.parse(typeUrl));
            if (typeResponse.statusCode == 200) {
              var typeData = jsonDecode(typeResponse.body);
              for (var t in typeData['types']) {
                type.add(t['type']['name']);
              }
            } else {
              print('Error fetching type: ${typeResponse.statusCode}');
            }
            loadedPokemons.add(MiniPokemon(
              name: name,
              imageUrl: imageUrl,
              type: type,
            ));       
          }
        }

          setState(() {
            pokemonsmini = loadedPokemons;
          });

        } else {
          print('Error fetching list: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
      for(var i = 0; i < pokemonsmini.length; i++) {
        print(pokemonsmini[i].getName());
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pokedex',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white
          ),
        ),
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
      bottomNavigationBar: BottomNavigationBar(

        currentIndex: index,
        onTap: (i){
          setState(() {
            index = i;
          });

          if (i == 1) {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchPage(),
            ),
          );
          } else if (i == 2) {
            Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Dashboard(),
            ),
          );          
          }
        },

        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        selectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        unselectedItemColor: Colors.white,
        unselectedLabelStyle: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            
            icon: Icon(Icons.search),
            label: 'Search',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person,
          ),
            label: 'dashboard',
          ),
        ],
      ),
    );
  }
}