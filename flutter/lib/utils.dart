import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> getMovieJson(String movie_name) async {
  var apiKey = getApiKey();
  var url = 'http://api.themoviedb.org/3/search/movie?api_key=${apiKey}&query=${movie_name}';
  var response = await http.get(url);
  var data = json.decode(response.body);
  var re = data['results'];
  return re[0];
}

Future<List> getDataUtils() async {
  List movieNames = ['Forrest Gump', 'Shawshank Redemption', 'Pulp Fiction'];
  List data = [];
  for (String name in movieNames) {
    data.add(await getMovieJson(name));
  }
  return data;
}
