import 'dart:convert';
import 'dart:core';
import 'dart:ffi';
import 'dart:math';

import 'package:http/http.dart' as http;

import '../models/Film.dart';
import '../models/Genre.dart';
import 'FilmAPICalls.dart';
import 'RaumAPICalls.dart';

class MovieCalls {
  String RaumID;
  String APIKey = "Key to API";
  String token = "Token";
  List<dynamic> movielist = [];

  MovieCalls({required this.RaumID});

  Future<void> getAllMovies(genre, {int number = 1}) async {
    final response = await http.get(
        Uri.parse(
            'https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=$number&with_genres=$genre'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      String responseBody = response.body;
      Map<String, dynamic> jsonResponse = json.decode(responseBody);
      movielist += jsonResponse['results'];
    }
  }

  Future<List<Genre>> getGenres() async {
    final response = await http.get(
        Uri.parse('https://api.themoviedb.org/3/genre/movie/list'),
        headers: {
          "Content-type": "application/json",
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode == 200) {
      List<dynamic> responseData = jsonDecode(response.body)['genres'];
      return responseData.map((data) => Genre.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Genres: ${jsonDecode(response.body)}');
    }
  }

  Future<Film> getRandomFilm(raumID) async {
    var genre = await GetGenreFromRaum(raumID);
    if (movielist.length == 0) {
      await this.getAllMovies(genre);
    }
    int listLength = movielist.length;
    Random random = Random();
    int randomIndex = random.nextInt(listLength);
    List<String> genres =
        await getGenresByID(movielist[randomIndex]["genre_ids"]);
    var film = await CreateFilm(
        movielist[randomIndex]["title"],
        movielist[randomIndex]["id"],
        RaumID,
        movielist[randomIndex]["overview"],
        "https://image.tmdb.org/t/p/w500" +
            movielist[randomIndex]["poster_path"],
        genres,
        movielist[randomIndex]["adult"],
        movielist[randomIndex]["vote_average"]);
    movielist.removeAt(randomIndex);
    return film;
  }

  Future<List<String>> getGenresByID(List<dynamic> genreIds) async {
    var genres = await getGenres();
    List<String> genreNames = [];
    for (int genreID in genreIds) {
      for (Genre genre in genres) {
        if (genre.id == genreID) {
          genreNames.add(genre.name);
          break;
        }
      }
    }
    return genreNames;
  }
}

