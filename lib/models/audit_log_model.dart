class AuditLog {
  final int id;
  final int userId;
  final String action;
  final String timestamp;

  AuditLog({
    required this.id,
    required this.userId,
    required this.action,
    required this.timestamp,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
        id: int.parse(json['id'].toString()),
        userId: int.parse(json['user_id'].toString()),
        action: json['action'],
        timestamp: json['timestamp'],
      );
}
