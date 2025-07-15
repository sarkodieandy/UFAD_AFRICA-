class CreditScore {
  final int id;
  final int userId;
  final int score;
  final String tier;
  final String updatedAt;

  CreditScore({
    required this.id,
    required this.userId,
    required this.score,
    required this.tier,
    required this.updatedAt,
  });

  factory CreditScore.fromJson(Map<String, dynamic> json) => CreditScore(
        id: int.parse(json['id'].toString()),
        userId: int.parse(json['user_id'].toString()),
        score: int.parse(json['score'].toString()),
        tier: json['tier'],
        updatedAt: json['updated_at'],
      );
}
