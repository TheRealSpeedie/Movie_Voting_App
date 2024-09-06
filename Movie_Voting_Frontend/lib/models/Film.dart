
class Film {
  final int Votes;
  final String Filmname;
  final String RaumId;
  final int MovieApiID;
  final int ID;
  final String Description;
  final String Image;
  final List<String> Genres;
  final bool ForAdult;
  final double  VoteAverage;

  const Film(
      {required this.Votes,
      required this.Filmname,
      required this.RaumId,
      required this.MovieApiID,
      required this.ID,
      required this.Description,
      required this.Image,
      required this.Genres,
      required this.ForAdult,
        required this.VoteAverage,
      });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      Votes: json['votes'] as int,
      Filmname: json['filmName'] as String,
      RaumId: json['Raum'] as String,
      MovieApiID: json['movieApiID'] as int,
      ID: json['id'] as int,
      Description: json['description'] as String,
      Image: json['image'] as String,
      Genres: (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      ForAdult: json['forAdult'] as bool,
      VoteAverage: (json['voteAverage']),
    );
  }

  Map<String, dynamic> toJson() => {
        'votes': Votes,
        'filmName': Filmname,
        'Raum': RaumId,
        "movieApiID": MovieApiID,
        "ID": ID,
        'description': Description,
        'image': Image,
        'genres': Genres,
        'forAdult': ForAdult,
    'voteAverage': VoteAverage,
      };
}
