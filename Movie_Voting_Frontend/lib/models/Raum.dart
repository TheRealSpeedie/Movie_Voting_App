class Raum {
  String id;
  int AmountMembers;
  int StopCount;
  int Genre;

  Raum({
    required this.AmountMembers,
    required this.StopCount,
    required this.id,
    required this.Genre
  });

  factory Raum.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'AmountMembers': int amountMembers,
      'StopCount': int stopCount,
      'id' : String ID,
      'Genre_ID': int genre
      } =>
          Raum(
            AmountMembers: amountMembers,
            StopCount: stopCount,
            id: ID,
            Genre: genre
          ),
      _ => throw const FormatException('Failed to load Raum.'),
    };
  }
    Map<String, dynamic> toJson() => {
      'AmountMembers': AmountMembers,
      'StopCount': StopCount,
      'id' : id,
      'Genre_ID': Genre
    };
}

