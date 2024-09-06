import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_voting_frontend/API/FilmAPICalls.dart';
import 'package:movie_voting_frontend/API/MovieAPICalls.dart';
import 'package:movie_voting_frontend/API/ThemeAPICalls.dart';
import 'package:movie_voting_frontend/Components/filmDetails.dart';
import 'package:movie_voting_frontend/pages/results.dart';

import '../API/RaumAPICalls.dart';
import '../models/Raum.dart';
import '../models/Film.dart';

class VotingScreen extends StatefulWidget {
  final String raumId;
  VotingScreen(this.raumId, {super.key});
  @override
  _VotingScreen createState() => _VotingScreen();
}

class _VotingScreen extends State<VotingScreen> {
  Raum? raum;
  late MovieCalls movieCalls;
  late Film film;
  String? title;
  String? description;
  String? image;

  @override
  initState() {
    GetRaumByID(widget.raumId).then((value) {
      setState(() {
        raum = value;
      });
    });
    movieCalls = MovieCalls(RaumID: widget.raumId);
    startPeriodicCheckStop();
    getMovie().then((value) {
      setState(() {
        film = value;
        title = value.Filmname;
        description = value.Description;
        image = value.Image;
      });
    });
  }

  Future<Film> getMovie() async {
    Film film = await movieCalls.getRandomFilm(widget.raumId);
    return film;
  }

  Future<void> _stopVoting(BuildContext context) async {
    final stopCount = await getStopCount(raum?.id);
    setState(() {
      raum?.StopCount = stopCount;
    });
    await UpdateStopCount(await GetRaumByID(raum?.id));
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(film.Filmname),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width * 0.8,
            child: SingleChildScrollView(
              child: FilmDetails(film: film),
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void startPeriodicCheckStop() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (await CheckStopCount(widget.raumId)) {
        timer.cancel();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(widget.raumId)),
        );
      }
    });
  }

  void _likeMovie() async {
    await UpdateVotes(film);
    final newfilm = await getMovie();
    setState(() {
      film = newfilm;
      title = newfilm.Filmname;
      description = newfilm.Description;
      image = newfilm.Image;
    });
  }

  void _dislikeMovie() async {
    final newfilm = await getMovie();
    setState(() {
      film = newfilm;
      title = newfilm.Filmname;
      description = newfilm.Description;
      image = newfilm.Image;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
            backgroundColor: theme.colorScheme.inversePrimary,
            title: const Text("Voting"),
            automaticallyImplyLeading: false),
        body: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Raum: ', style: TextStyle(
            fontWeight: FontWeight.bold),),
              Text('${raum?.id}'),
              IconButton(
                icon: const Icon(Icons.copy),
                tooltip: 'Copy Roomnumber to Clipboard',
                onPressed: () async{
                  await Clipboard.setData(ClipboardData(text: raum!.id));
                },
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
                onTap: () {
                  _dialogBuilder(context);
                },
                child: Container(
                  height: 500,
                  child: Dismissible(
                    key: Key(title.toString()),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        _likeMovie();
                      } else if (direction == DismissDirection.endToStart) {
                        _dislikeMovie();
                      }
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.primary),
                          image: DecorationImage(
                            image: NetworkImage(image != null && image != ""
                                ? image!
                                : 'no Picture'),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.black45,
                              child: Text(
                                title != null && title != "" ? title! : 'N/A',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                            Container(
                              color: Colors.black45,
                              child: Text(
                                  description != null && description != ""
                                      ? description!
                                      : 'N/A'),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme.colorScheme.onPrimary),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme.colorScheme.primary)),
                                    onPressed: () {
                                      _dislikeMovie();
                                    },
                                    child: const Text("Dislike"),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, right: 10),
                                  child: TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme.colorScheme.onPrimary),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                theme.colorScheme.primary)),
                                    onPressed: () {
                                      _likeMovie();
                                    },
                                    child: const Text("Like"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text('Stopped ${raum?.StopCount}'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    _stopVoting(context);
                  },
                  child: const Text('Stop Voting'),
                ),
              )
            ],
          ),
        ]));
  }
}
