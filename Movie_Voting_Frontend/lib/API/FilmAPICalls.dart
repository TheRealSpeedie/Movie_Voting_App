import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_voting_frontend/models/Film.dart';

import '../Components/ExceptionThrower.dart';

Future<Film> CreateFilm(title, movieAPIID, RaumID, description, image, genres,
    forAdult, voteAverage) async {
  var film = Film(
      Votes: 0,
      Filmname: title,
      MovieApiID: movieAPIID,
      RaumId: RaumID,
      ID: 0,
      Description: description,
      Image: image,
      Genres: genres,
      ForAdult: forAdult,
      VoteAverage: voteAverage);
  final response = await http.post(Uri.parse('http://127.0.0.1:8000/api/film/'),
      body: jsonEncode(film.toJson()),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to create Film")
      .CheckForException(response, expectedStatusCode: 201);
  return Film.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<Film> getFilmByName(Filmname) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/film/$Filmname/'));
  await ExceptionThrower(error: "Failed to get Film by Name $Filmname")
      .CheckForException(response);
  return Film.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<void> UpdateVotes(film) async {
  final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/film/${film.ID}/'),
      body: jsonEncode({"votes": film.Votes + 1}),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to update Votes")
      .CheckForException(response);
}

Future<Film> fetchAllFilm() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/film/'));

  await ExceptionThrower(error: "Failed to get all Film")
      .CheckForException(response);
  return Film.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<List<Film>> GetAllMoviesFromRaum(RaumID) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/film/raum/$RaumID'));
  await ExceptionThrower(error: "Failed to create Film").CheckForException(
      response,
      expectedStatusCode: 200,
      additionalStatusCode: 204);
  if (response.statusCode == 200) {
    List<dynamic> responseData = jsonDecode(response.body);
    return responseData.map((data) => Film.fromJson(data)).toList();
  } else {
    return [];
  }
}
