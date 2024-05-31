import 'package:intl/intl.dart';

class Message {
  int? id;
  int discussionId;
  String text;
  DateTime timestamp;

  Message(
      {this.id,
      required this.discussionId,
      required this.text,
      DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  String formatTimestamp() {
    final now = DateTime.now();
    final difference = now.difference(timestamp).inDays;

    if (difference == 0) {
      return DateFormat('h:mm a').format(timestamp);
    } else if (difference == 1) {
      return 'Hier ${DateFormat('h:mm a').format(timestamp)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(timestamp);
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discussion_id': discussionId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      discussionId: map['discussion_id'],
      text: map['text'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  @override
  String toString() {
    return 'Message{id: $id, discussionId: $discussionId, text: $text, timestamp: $timestamp}';
  }
}
