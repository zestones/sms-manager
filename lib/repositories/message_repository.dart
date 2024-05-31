import 'package:namer_app/models/message.dart';
import 'package:namer_app/utils/database_helper.dart';

class MessageRepository {
  final DatabaseHelper _databaseHelper;

  MessageRepository(this._databaseHelper);

  Future<int> insertMessage(Message message) async {
    final db = await _databaseHelper.database;
    return await db!.insert('Message', message.toMap());
  }

  Future<List<Message>> getAllMessagesByDiscussionId(discussionId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Message',
      where: 'discussion_id = ?',
      whereArgs: [discussionId],
    );
    return List.generate(maps.length, (i) {
      return Message(
        id: maps[i]['id'],
        discussionId: maps[i]['discussion_id'],
        text: maps[i]['text'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }

  Future<void> deleteAllMessages() async {
    final db = await _databaseHelper.database;
    await db!.delete('Message');
  }
}
