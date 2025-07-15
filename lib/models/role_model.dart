class Role {
  final int id;
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: int.parse(json['id'].toString()),
        name: json['name'],
      );
}
