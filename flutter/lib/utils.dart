import 'config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map> getMovieJson(String movieName) async {
  var apiKey = getApiKey();
  var url = "http://api.themoviedb.org/3/search/movie?api_key=${apiKey}&query=${movieName}";
  var response = await http.get(url);
  var data = json.decode(response.body);
  var re = data['results'];
  return re[0];
}

Future<List> getDataUtils(movieNamesRaw) async {
  String movieNamesStr = movieNamesRaw.replaceAll('\'', '\"');
  List movieNames = json.decode(movieNamesStr);
  List data = [];
  for (String name in movieNames) {
    // need more regex for edge cases
    String nameOnly = name.replaceAll(RegExp(r'\(.*\)'), '');
    String shortName = nameOnly.replaceAll(RegExp(r'\, .*'), '');

    data.add(await getMovieJson(shortName));
  }

  return data;
}
