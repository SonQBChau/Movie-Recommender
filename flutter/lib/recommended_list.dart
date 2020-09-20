import 'dart:async';
import 'dart:convert';
import 'package:flutter_movify/movie_list.dart';
import 'package:flutter_movify/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RecommendedList extends StatefulWidget {
  final String movie;
  final int rating;

  const RecommendedList({Key key, this.movie, this.rating}) : super(key: key);

  @override
  RecommendedListState createState() {
    return new RecommendedListState();
  }
}

class RecommendedListState extends State<RecommendedList> {
  var movies;
  Color mainColor = const Color(0xff3C3261);

  Future<List> getRecommended(movie, rating) async {
    var url = 'https://notebook-schau.p.tnnl.in/get_recommended';
    Map<String, String> headers = {"Content-type": "application/json"};
    String json = jsonEncode({'movie': '$movie', 'rating': rating});
    print(json);
    // make POST request
    Response response = await post(url, headers: headers, body: json);

    // check the status code for the result
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response.body);
      String body = response.body;

      // print(body);
      final Future str2 = getDataUtils(body);
      return str2;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print(response.statusCode);
      throw Exception('Failed to get movies');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Future movieList = getRecommended(this.widget.movie, this.widget.rating);

    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: FutureBuilder(
              future: movieList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  movies = snapshot.data;
                  return new Column(
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
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (c) => MovieList()), (route) => false);
                          },
                          child: new Text(
                            'Back to Menu',
                            style: new TextStyle(
                                color: Colors.white, fontFamily: 'Arvo', fontSize: 20.0),
                          ),
                        ),
                        decoration: new BoxDecoration(
                            borderRadius: new BorderRadius.circular(10.0),
                            color: mainColor),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                // By default, show a loading spinner
                return CircularProgressIndicator();
              },
            ),
          )),
    );
  }
}

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
            fontSize: 40.0, color: mainColor, fontWeight: FontWeight.bold, fontFamily: 'Arvo'),
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
    var full_img_url;

    if (movies[i]['poster_path'] != null && movies[i]['poster_path'].length != 0) {
      full_img_url = NetworkImage(image_url + movies[i]['poster_path']);
    } else {
      full_img_url = AssetImage('assets/no_image.jpg');
    }

    return new Column(
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Padding(
              padding: const EdgeInsets.all(0.0),
              child: new Container(
                margin: const EdgeInsets.all(16.0),
                child: new Container(
                  width: 70.0,
                  height: 70.0,
                ),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: Colors.grey,
                  image: new DecorationImage(image: full_img_url, fit: BoxFit.cover),
                  boxShadow: [
                    new BoxShadow(color: mainColor, blurRadius: 5.0, offset: new Offset(2.0, 5.0))
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
                    style: new TextStyle(color: const Color(0xff8785A4), fontFamily: 'Arvo'),
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
