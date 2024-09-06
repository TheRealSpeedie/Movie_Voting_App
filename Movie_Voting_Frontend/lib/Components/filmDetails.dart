import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_voting_frontend/models/Film.dart';

class FilmDetails extends StatelessWidget {
  final Film film;

  FilmDetails({
    required this.film,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(image: NetworkImage(film.Image), height: 200),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Zusammenfassung: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text("${film.Description}"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Altersfreigabe: ${film.ForAdult == true ? "über 18" : "unter 18"}',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Bewertung:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: film.VoteAverage > 0
                    ? RatingBar.builder(
                  initialRating: film.VoteAverage / 2,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0.3),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                )
                    : Text("Keine Bewertungen vorhanden"),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'Genres:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: film.Genres.map((genre) => Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    genre,
                    style: TextStyle(fontSize: 16),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),

      ],
    );
  }
}
