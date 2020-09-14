import 'dart:async';
import 'dart:convert';
import 'package:flutter_movify/sample_movies.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'movie_detail.dart';
import 'config.dart';



class RecommendedList extends StatefulWidget {
  @override
  RecommendedListState createState() {
    return new RecommendedListState();
  }
}

class RecommendedListState extends State<RecommendedList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  void getData() async {
    // var data = await getJson();
    var data = movieData;
    print(movieData);


    setState(() {
      movies = data['results'];
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
      backgroundColor: Colors.white,

      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new MovieTitle(mainColor),
            new Expanded(
              child: new ListView.builder(
                  itemCount: movies == null ? 0 : movies.length,
                  itemBuilder: (context, i) {
                    return new FlatButton(
                      child: new MovieCell(movies, i),
                      padding: const EdgeInsets.all(0.0),

                      color: Colors.white,
                    );
                  }),
            ),
            Container(
              width: 200.0,
              height: 60.0,
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {

                },
                child: new Text(
                  'Back to Menu',
                  style: new TextStyle(
                      color: Colors.white,
                      fontFamily: 'Arvo',
                      fontSize: 20.0),
                ),
              ),
              decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: const Color(0xaa3C3261)),
            )
          ],
        ),
      ),
    );
  }
}

// Future<Map> getJson() async {
//   var apiKey = getApiKey();
//   var url = 'http://api.themoviedb.org/3/discover/movie?api_key=${apiKey}';
//   var response = await http.get(url);
//   return json.decode(response.body);
// }

class MovieTitle extends StatelessWidget {
  final Color mainColor;

  MovieTitle(this.mainColor);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 32, 16.0, 16.0),
      child: new Text(
        'Recommended',
        style: new TextStyle(
            fontSize: 40.0,
            color: mainColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'Arvo'),
        textAlign: TextAlign.left,
      ),
    );
  }
}

class MovieCell extends StatelessWidget {
  final movies;
  final i;
  Color mainColor = const Color(0xff3C3261);
  var image_url = 'https://image.tmdb.org/t/p/w500/';
  MovieCell(this.movies, this.i);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
//                                child: new Image.network(image_url+movies[i]['poster_path'],width: 100.0,height: 100.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(
                      image: new NetworkImage(
                          image_url + movies[i]['poster_path']),
                      fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(
                        color: mainColor,
                        blurRadius: 5.0,
                        offset: new Offset(2.0, 5.0))
                  ],
                ),
              ),
            ),
            new Expanded(
                child: new Container(
                  margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                  child: new Column(
                    children: [
                      new Text(
                        movies[i]['title'],
                        style: new TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Arvo',
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                      new Padding(padding: const EdgeInsets.all(2.0)),
                      new Text(
                        movies[i]['overview'],
                        maxLines: 3,
                        style: new TextStyle(
                            color: const Color(0xff8785A4), fontFamily: 'Arvo'),
                      )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                )),
          ],
        ),
        new Container(
          width: 300.0,
          height: 0.5,
          color: const Color(0xD2D2E1ff),
          margin: const EdgeInsets.all(16.0),
        )
      ],
    );
  }
}
