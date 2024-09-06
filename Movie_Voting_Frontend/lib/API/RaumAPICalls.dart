import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_voting_frontend/Components/ExceptionThrower.dart';
import 'package:uuid/uuid.dart';

import '../models/Raum.dart';

Future<http.Response> getAllRaum() {
  return http.get(Uri.parse('http://127.0.0.1:8000/api/raum/'));
}

Future<Raum> fetchAllRaum() async {
  final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/raum/'));
  await ExceptionThrower(error: "Failed to get all Raums")
      .CheckForException(response);
  return Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<bool> ExistRaum(id) async {
  if (id == "") return false;
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/raum/$id'));

  if (response.statusCode == 200) {
    var raum = Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    raum = await UpdateAmountMembers(raum);
    return true;
  } else {
    return false;
  }
}

Future<Raum> UpdateGenre(Genre_ID, RaumID) async {
  Raum raum = await GetRaumByID(RaumID);
  final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/raum/${raum.id}/'),
      body: jsonEncode({"Genre_ID": Genre_ID}),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to update Genre")
      .CheckForException(response);
  return raum;
}

Future<int> GetGenreFromRaum(RaumID) async {
  Raum raum = await GetRaumByID(RaumID);
  return raum.Genre;
}

Future<Raum> UpdateAmountMembers(raum) async {
  raum.AmountMembers += 1;
  final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/raum/${raum.id}'),
      body: jsonEncode({"AmountMembers": raum.AmountMembers}),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to update Amount Members")
      .CheckForException(response);
  return raum;
}

Future<Raum> CreateRaum() async {
  Raum raum =
      new Raum(AmountMembers: 1, StopCount: 0, id: Uuid().v4(), Genre: 0);
  final response = await http.post(Uri.parse('http://127.0.0.1:8000/api/raum/'),
      body: jsonEncode(raum.toJson()),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to Create Raum")
      .CheckForException(response, expectedStatusCode: 201);
  return Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

Future<Raum> GetRaumByID(id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/raum/$id'));
  await ExceptionThrower(error: "Failed to Get Raum By ID")
      .CheckForException(response);
  return Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
}

void DeleteRaum(ID) async {
  final response =
      await http.delete(Uri.parse('http://127.0.0.1:8000/api/raum/$ID/'));
  await ExceptionThrower(error: "Failed to Create Raum")
      .CheckForException(response, expectedStatusCode: 204);
}

Future<bool> CheckStopCount(raumID) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/raum/${raumID}'));

  await ExceptionThrower(error: "Failed to Check StopCount")
      .CheckForException(response);
  var parsedRaum =
      Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  return parsedRaum.StopCount >= (parsedRaum.AmountMembers / 2);
}

Future<int> getStopCount(id) async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/raum/$id'));

  await ExceptionThrower(error: "Failed to Get StopCount")
      .CheckForException(response);
  var raum = Raum.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  return raum.StopCount;
}

Future<int> UpdateStopCount(Raum raum) async {
  raum.StopCount += 1;
  final response = await http.patch(
      Uri.parse('http://127.0.0.1:8000/api/raum/${raum.id}/'),
      body: jsonEncode({"StopCount": raum.StopCount}),
      headers: {"Content-type": "application/json"});
  await ExceptionThrower(error: "Failed to Update StopCount")
      .CheckForException(response);
  return raum.StopCount;
}
