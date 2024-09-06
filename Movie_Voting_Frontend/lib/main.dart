import 'package:flutter/material.dart';
import 'package:movie_voting_frontend/pages/createRoom.dart';
import 'package:movie_voting_frontend/pages/joinRoom.dart';
import 'package:movie_voting_frontend/pages/login.dart';
import 'package:provider/provider.dart';

import 'API/RaumAPICalls.dart';
import 'Components/ThemeManager.dart';
import 'Themes/darkTheme.dart';
import 'Themes/lightTheme.dart';
import 'models/Raum.dart';

void main() {
  return runApp(ChangeNotifierProvider<ThemeNotifier>(
    create: (_) => new ThemeNotifier(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, theme, _) => MaterialApp(
              theme: theme.getTheme(),
              home: const MyHomePage(title: 'Movie Voting'),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<void> _createRoom(BuildContext context) async {
    Raum raum = await CreateRaum();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateScreen(raum.id),
        ));
  }

  void _joinRoom(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JoinRoomScreen()),
    );
  }

  void _login(BuildContext context){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignInDemo()),
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData themedata = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: themedata.colorScheme.inversePrimary,
          title: Text(widget.title),
          automaticallyImplyLeading: false),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    themedata.colorScheme.primary),
              ),
              onPressed: () {
                _createRoom(context);
              },
              child: Text("Create Room"),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    themedata.colorScheme.secondary),
              ),
              onPressed: () {
                _joinRoom(context);
              },
              child: Text("Join Room"),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(
                    themedata.colorScheme.secondary),
              ),
              onPressed: () {
                _login(context);
              },
              child: Text("Login"),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
