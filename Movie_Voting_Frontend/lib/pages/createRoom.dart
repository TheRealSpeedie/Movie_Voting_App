import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:movie_voting_frontend/API/ThemeAPICalls.dart';
import 'package:movie_voting_frontend/models/Genre.dart';
import 'package:movie_voting_frontend/pages/createTheme.dart';
import 'package:movie_voting_frontend/pages/voting.dart';
import 'package:provider/provider.dart';

import '../API/MovieAPICalls.dart';
import '../API/RaumAPICalls.dart';
import '../Components/ThemeManager.dart';
import '../models/Raum.dart';

class CreateScreen extends StatefulWidget {
  final String raumId;
  CreateScreen(this.raumId, {super.key});
  @override
  _CreateScreen createState() => _CreateScreen();
}

class _CreateScreen extends State<CreateScreen> {
  Raum? raum;
  late MovieCalls movieCalls;
  String? dropdownvalue;
  String? themeValue;
  int? currentID;

  @override
  initState() {
    GetRaumByID(widget.raumId).then((value) {
      setState(() {
        raum = value;
      });
    });
    movieCalls = MovieCalls(RaumID: widget.raumId);
  }

  void goToVoting(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VotingScreen(widget.raumId),
        ));
  }

  Future<void> _create(context, Genre_ID) async {
    await UpdateGenre(Genre_ID, widget.raumId);
    await CreateTheme(Theme.of(context).colorScheme, widget.raumId);
    goToVoting(context);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeOfContext = Theme.of(context);
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
            theme: theme.getTheme(),
            home: Scaffold(
                appBar: AppBar(
                  backgroundColor: themeOfContext.colorScheme.inversePrimary,
                  title: const Text("Raum Informationen"),
                ),
                body: FutureBuilder<List<Genre>>(
                    future: movieCalls.getGenres(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Fehler: ${snapshot.error}');
                      } else {
                        List<Genre>? genres = snapshot.data;
                        if (dropdownvalue == null) {
                          dropdownvalue = genres != null && genres.isNotEmpty
                              ? genres.first.name
                              : 'N/A';
                          currentID = genres != null && genres.isNotEmpty
                              ? genres.first.id
                              : 0;
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Genre:'),
                              SizedBox(height: 10),
                              DropdownButton<String>(
                                value: dropdownvalue,
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: TextStyle(
                                  color: themeOfContext.colorScheme.primary,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    Genre selectedGenre = genres!.firstWhere(
                                        (genre) => genre.name == value);
                                    setState(() {
                                      currentID = selectedGenre.id;
                                      dropdownvalue = value;
                                    });
                                  }
                                },
                                items: genres?.map<DropdownMenuItem<String>>(
                                  (Genre genre) {
                                    return DropdownMenuItem<String>(
                                      value: genre.name,
                                      child: Text(genre.name),
                                    );
                                  },
                                ).toList(),
                              ),
                              SizedBox(height: 20), // Abstand hinzugefügt
                              TextButton(
                                style: ButtonStyle(
                                  foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                    themeOfContext.colorScheme.primary,
                                  ),
                                ),
                                onPressed: () {
                                  _create(context, currentID);
                                },
                                child: Text("Create Room"),
                              ),
                              SizedBox(height: 20), // Abstand hinzugefügt
                              DropdownButton<String>(
                                value:
                                    themeValue != null && themeValue!.isNotEmpty
                                        ? themeValue
                                        : 'dark',
                                icon: const Icon(Icons.arrow_downward),
                                elevation: 16,
                                style: TextStyle(
                                  color: themeOfContext.colorScheme.primary,
                                ),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String? value) {
                                  if (value != null) {
                                    if (value == "Costum") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CreateThemeScreen(widget.raumId, currentID!),
                                          ));
                                    }else if(value == "light"){
                                      theme.setMode("light");
                                    }else{
                                      theme.setMode("dark");
                                    }
                                    setState(() {
                                      themeValue = value;
                                    });
                                  }
                                },
                                items: <String>['light', 'dark', 'Costum']
                                    .map<DropdownMenuItem<String>>(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  },
                                ).toList(),
                              ),
                            ],
                          ),
                        );
                      }
                    }))));
  }
}
