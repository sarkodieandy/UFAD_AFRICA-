class Location {
  final int id;
  final String name;

  Location({required this.id, required this.name});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(id: json['id'], name: json['name']);
}
