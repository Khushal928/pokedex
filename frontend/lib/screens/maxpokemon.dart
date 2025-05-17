import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';


class Maxpokemon extends StatefulWidget {
  @override
  final String name;
  Maxpokemon({Key? key, required this.name}) : super(key: key);
  _MaxpokemonState createState() => _MaxpokemonState();
}

class _MaxpokemonState extends State<Maxpokemon> {

  final tradecontroller = TextEditingController();
  String username = '';

  Map<String, dynamic> pokemondata = {};
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

  bool checked = false;
  bool captured = false;


  @override
  void initState() {
    super.initState();
    username = Hive.box('userdata').get('username', defaultValue: '');
    loadAll();
  }

  Future<void> loadAll() async {
    await getinfo(widget.name);
  }



  Future<void> getinfo(String name)async {
    var url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$name');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      var name = data['name'];
      var id = data['id'];
      var imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
      List<String> type = [];
      Color color;



      
        for (var t in data['types']) {
          type.add((t['type']['name']));}
        
        if(type.length==2){
          color = Color.lerp(typeColors[type[0]], typeColors[type[1]], 0.5)!;
        }else{
          color = typeColors[type[0]] ?? Colors.grey;
        }

  



      
        setState(() {
          pokemondata['name'] = name;
          pokemondata['id'] = id;
          pokemondata['imageUrl'] = imageUrl;
          pokemondata['type'] = type;
          pokemondata['height'] = data['height'];
          pokemondata['weight'] = data['weight'];
          pokemondata['abilities'] = data['abilities'];
          pokemondata['moves'] = data['moves'];
          pokemondata['color'] = color;
          pokemondata['stats'] = data['stats']; 
        }); 
        print(pokemondata);
        await getuserinfo();


    } else {
      print('Error: ${response.statusCode}');
    }
  }

  Future<void> getuserinfo()async{
    int pokeid =  pokemondata["id"];

    final url = Uri.parse('http://192.168.13.148:5000/check');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'pokeid': pokeid,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['captured']){
        setState(() {
          checked = true;
          captured = true;
        });

      }else{
        setState(() {
          checked = true;
          captured = false;
        });
      }
    }
  }

  void capture()async{
    int pokeid =  pokemondata["id"];

    final url = Uri.parse('http://192.168.13.148:5000/check');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'pokeid': pokeid,
      }),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['captured']){
        setState(() {
          checked = true;
          captured = true;
        });
      }
      else{
        setState(() {
          checked = true;
          captured = false;
        });
      }
    }
  }
  void trade(String tradeeusername)async{
    final url = Uri.parse('http://192.168.13.148:5000/trade');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'traderusername': username,
        'tradeeusername': tradeeusername,
        'pokeid': pokemondata['id'],
      }),
    );
    if (response.statusCode == 200) {

      final responseData = jsonDecode(response.body);
      if (responseData['traded']){
        setState(() {
          checked = true;
          captured = true;
        });
      }else{
        setState(() {
          checked = true;
          captured = false;
        });
      }
    }
  }

  @override
Widget build(BuildContext context) {
  if (pokemondata.isEmpty) {
    return Center(child: CircularProgressIndicator());
  }
  Widget actionButton;
    if (checked && !captured) {
      actionButton = ElevatedButton(
        onPressed: () {capture();},
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text('Capture', style: TextStyle(color: Colors.black)),
          ),
      );
    }else if (checked && captured) {
      actionButton = Container(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Column(
    children: [
      TextField(
        controller: tradecontroller,
        decoration: const InputDecoration(
          labelText: 'Enter tradee username',
        ),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: () {
          final tradee = tradecontroller.text.trim();
          if (tradee.isNotEmpty) {
            trade(tradee);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Text('Trade', style: TextStyle(color: Colors.black)),
        ),
      ),
    ],
  ),
);

    } else {
      actionButton = ElevatedButton(
        onPressed: () {capture();},
        style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: CircularProgressIndicator()
      );
    }

return Scaffold(
  backgroundColor: pokemondata['color'],
  body: Center(
    child: SingleChildScrollView(
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          children: [
            Text(
              pokemondata['name'].toString().toUpperCase(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Image.network(pokemondata['imageUrl'], height: 150),
            const SizedBox(height: 10),

            Wrap(
              spacing: 8,
              children: (pokemondata['type'] as List<dynamic>).map<Widget>((type) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Height and Weight
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20,right: 10,top: 5),

                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      
                      child: const Text(
                        'Height',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${pokemondata['height']}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20,right: 10,top: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Weight',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${pokemondata['weight']}'),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Abilities',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Column(
              children: (pokemondata['abilities'] as List<dynamic>)
                  .map<Widget>((a) => Text(a['ability']['name']))
                  .toList(),
            ),

            const SizedBox(height: 20),

            const Text(
              'Moves',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Column(
              children: (pokemondata['moves'] as List<dynamic>)
                  .take(5)
                  .map<Widget>((m) => Text(m['move']['name']))
                  .toList(),
            ),
            

            const SizedBox(height: 20),

          actionButton,
          ],
        ),
      ),
      
    ),
    
  ),
);
}
}