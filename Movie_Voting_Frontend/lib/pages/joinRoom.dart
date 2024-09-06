import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_voting_frontend/API/RaumAPICalls.dart';
import 'package:movie_voting_frontend/models/Raum.dart';
import 'package:movie_voting_frontend/pages/voting.dart';

class JoinRoomScreen extends StatefulWidget {
  @override
  _JoinRoomScreen createState() => _JoinRoomScreen();
}


class _JoinRoomScreen extends State<JoinRoomScreen> {
  final TextEditingController _roomController = TextEditingController();
  Future<void> _Overview(BuildContext context) async {
    if(await ExistRaum(_roomController.text)  && _roomController.text.isNotEmpty){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VotingScreen(_roomController.text),
      ));
    }else{
      _dialogBuilder(context);
      _roomController.text = "";
    }

  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Raum existiert nicht"),
            content: const Text("Die eingebene Raum-ID konnte nicht zu einem Raum zugeordnet werden."),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme
                      .of(context)
                      .textTheme
                      .labelLarge,
                ),
                child: const Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.inversePrimary,
        title: Text("Join Room"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxWidth: 200,
              ),
              child: TextField(
                controller: _roomController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Raumnummer:',
                  border: OutlineInputBorder(),
                ),
            )
            ), TextButton(onPressed: () {_Overview(context); }, child: Text("Join"))
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}