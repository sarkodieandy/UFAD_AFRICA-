// lib/models/activity_model.dart
class Activity {
  final String username;
  final String action;
  final String timestamp; // Keeping as String to match HTML exactly

  Activity({
    required this.username,
    required this.action,
    required this.timestamp,
  });

  // Helper method to format for display
  String get formattedDate {
    // If you need to parse and reformat the date:
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} '
          '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return timestamp; // Return original if parsing fails
    }
  }
}