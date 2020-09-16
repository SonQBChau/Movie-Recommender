import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> getMovieJson(String movie_name) async {
  var apiKey = getApiKey();
  var url = 'http://api.themoviedb.org/3/search/movie?api_key=${apiKey}&query=${movie_name}';
  var response = await http.get(url);
  var data = json.decode(response.body);
  var re = data['results'];
  // print(await re[0]);
  return re[0];
}

Future<List> getDataUtils() async {
  List movieNames = ['Forrest Gump', 'Shawshank Redemption', 'Pulp Fiction',
    'The Silence of the Lambs', 'The Matrix', 'Jurassic Park', 'Terminator 2: Judgment Day',
  'Schindle List', 'Fight Club', 'Toy Story', 'American Beauty', 'Seven (1995)',
  'Independence Day', 'Apollo 13', 'The Godfather', 'The Fugitive', 'Batman (1989)',
    'Saving Private Ryan', 'Aladdin (1992)','Fargo', 'The Sixth Sense','True Lies',
    'Twelve Monkeys', 'Back to the Future', 'Gladiator' ];
  List data = [];
  for (String name in movieNames) {
    data.add(await getMovieJson(name));
  }
  return data;
}
