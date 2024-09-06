import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:movie_voting_frontend/Components/Colorpicker.dart';
import 'package:movie_voting_frontend/Components/ColorpickerController.dart';
import 'package:movie_voting_frontend/pages/voting.dart';
import 'package:provider/provider.dart';

import '../API/RaumAPICalls.dart';
import '../API/ThemeAPICalls.dart';
import '../Components/ThemeManager.dart';
import '../models/Raum.dart';

class CreateThemeScreen extends StatefulWidget {
  final String raumId;
  final int Genre_ID;
  CreateThemeScreen(this.raumId, this.Genre_ID, {super.key});
  @override
  _CreateThemeScreen createState() => _CreateThemeScreen();
}

class _CreateThemeScreen extends State<CreateThemeScreen> {
  Raum? raum;
  @override
  initState() {
    GetRaumByID(widget.raumId).then((value) {
      setState(() {
        raum = value;
      });
    });
  }

  _CreateThemeScreen();

  @override
  Widget build(BuildContext context) {
    ThemeData themeOfContext = Theme.of(context);
    Brightness _brightness = Brightness.light;
    final primary = ColorpickerController();
    final onPrimary = ColorpickerController();
    final secondary = ColorpickerController();
    final onSecondary = ColorpickerController();
    final background = ColorpickerController();
    final onBackground = ColorpickerController();
    final error = ColorpickerController();
    final onError = ColorpickerController();
    final surface = ColorpickerController();
    final onSurface = ColorpickerController();
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              home: Scaffold(
                appBar: AppBar(
                  backgroundColor: themeOfContext.colorScheme.inversePrimary,
                  title: const Text("Costum Theme erstellen"),
                  automaticallyImplyLeading: false,
                ),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      value: _brightness == Brightness.light ? "light" : "dark",
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
                        setState(() {
                          if (value == "light") {
                            _brightness = Brightness.light;
                          } else {
                            _brightness = Brightness.dark;
                          }
                        });
                      },
                      items: <String>['light', 'dark']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 200,
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 2,
                        children: <Widget>[
                          Colorpicker(text: "Primay", colorController: primary),
                          Colorpicker(text: "onPrimary", colorController: onPrimary),
                          Colorpicker(text: "secondary", colorController: secondary),
                          Colorpicker(text: "onSecondary", colorController: onSecondary),
                          Colorpicker(text: "surface", colorController: surface),
                          Colorpicker(text: "onSurface", colorController: onSurface),
                          Colorpicker(text: "error", colorController: error),
                          Colorpicker(text: "onError", colorController: onError),
                          Colorpicker(text: "background", colorController: background),
                          Colorpicker(text: "onBackground", colorController: onBackground),
                        ],
                      ),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: Theme.of(context).textTheme.labelLarge,
                      ),
                      child: const Text('Okay'),
                      onPressed: () async {
                        var colorsheme = ColorScheme(
                          brightness: _brightness,
                          background: background.color,
                          onBackground: onBackground.color,
                          primary: primary.color,
                          onPrimary: onPrimary.color,
                          secondary: secondary.color,
                          onSecondary: onSecondary.color,
                          surface: surface.color,
                          onSurface: onSurface.color,
                          error: error.color,
                          onError: onError.color,
                        );
                        theme.setTheme(colorsheme, widget.raumId);
                        await UpdateGenre(widget.Genre_ID, widget.raumId);
                        await CreateTheme(
                            Theme.of(context).colorScheme, widget.raumId);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VotingScreen(widget.raumId),
                            ));
                      },
                    ),
                  ],
                ),
              ),
            ));
  }
}
