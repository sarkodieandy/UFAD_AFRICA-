class Permission {
  final int id;
  final String name;

  Permission({required this.id, required this.name});

  factory Permission.fromJson(Map<String, dynamic> json) => Permission(
        id: int.parse(json['id'].toString()),
        name: json['name'],
      );
}
