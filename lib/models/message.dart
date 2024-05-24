class Message {
  int? id;
  int discussionId;
  String message;

  Message({this.id, required this.discussionId, required this.message});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'discussion_id': discussionId,
      'message': message,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      discussionId: map['discussion_id'],
      message: map['message'],
    );
  }

  @override
  String toString() {
    return 'Message{id: $id, discussionId: $discussionId, message: $message}';
  }
}
