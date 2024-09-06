class Genre {
  int id;
  String name;

  Genre({
    required this.name,
    required this.id
  });

  factory Genre.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
      'name': String Name,
      'id' : int ID
      } =>
          Genre(
            name: Name,
            id: ID,
          ),
      _ => throw const FormatException('Failed to load Raum.'),
    };
  }
  Map<String, dynamic> toJson() => {
    'name': name,
    'id' : id
  };
}

