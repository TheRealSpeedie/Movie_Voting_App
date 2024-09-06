import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:movie_voting_frontend/API/RaumAPICalls.dart';

import '../API/FilmAPICalls.dart';
import '../Components/podium.dart';
import '../main.dart';
import '../models/Film.dart';
import '../models/Raum.dart';

class ResultScreen extends StatefulWidget {
  final String raumId;
  ResultScreen(this.raumId, {super.key});
  @override
  _ResultScreen createState() => _ResultScreen();
}


class _ResultScreen extends State<ResultScreen> {
  Raum? raum;
  @override
  initState() {
    GetRaumByID(widget.raumId).then((value) {
      setState(() {
        raum = value;
      });
    });
  }
  _ResultScreen();

  Future<List<Film>> getTopThree() async {
    List<Film> movies = await GetAllMoviesFromRaum(raum?.id);
    if(movies.isEmpty){
      return [];
    }
    while(movies.length < 3){ movies.add(new Film(Votes: 0, Filmname: "", RaumId: "", MovieApiID: 1, ID: 1, Description: "", Image: "", Genres: [], ForAdult: false, VoteAverage: 0));}
    return movies.take(3).toList(); //
  }

  void _backToStart(context){
    DeleteRaum(raum?.id);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Movie Voting',)),
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: const Text("Resultate"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Film>>(
        future: getTopThree(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Text('Fehler bei GetTopThree: ${snapshot.error}');
          } else {
            List<Film>? movies = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  PodiumWidget(rank: 1, filmTitle: movies!.isEmpty || movies[0].Filmname == "" ?  'Kein Film': movies[0].Filmname ),
                  const SizedBox(height: 20),
                  PodiumWidget(rank: 2, filmTitle: movies!.isEmpty || movies[1].Filmname == ""?  'Kein Film' : movies[1].Filmname),
                  const SizedBox(height: 20),
                  PodiumWidget(rank: 3, filmTitle: movies!.isEmpty || movies[2].Filmname == "" ?  'Kein Film' : movies[2].Filmname),
                  TextButton(onPressed: () {_backToStart(context);}, child: const Text("Back to Start"))
                ],
              ),
            );
          }
        },
      ),
    );
  }
}