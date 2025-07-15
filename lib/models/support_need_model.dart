class SupportNeed {
  final int id;
  final String name;

  SupportNeed({required this.id, required this.name});

  factory SupportNeed.fromJson(Map<String, dynamic> json) => SupportNeed(
        id: int.parse(json['id'].toString()),
        name: json['name'],
      );
}
