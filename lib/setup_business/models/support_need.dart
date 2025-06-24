class SupportNeed {
  final int id;
  final String name;

  SupportNeed({required this.id, required this.name});

  factory SupportNeed.fromJson(Map<String, dynamic> json) =>
      SupportNeed(id: json['support_need_id'], name: json['name']);
}
