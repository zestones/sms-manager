import 'package:namer_app/models/discussion_participant.dart';
import 'package:namer_app/utils/database_helper.dart';

class DiscussionParticipantRepository {
  final DatabaseHelper _databaseHelper;

  DiscussionParticipantRepository(this._databaseHelper);

  Future<int> insertDiscussionParticipant(
      DiscussionParticipant discussionParticipant) async {
    final db = await _databaseHelper.database;
    return await db!
        .insert('DiscussionParticipant', discussionParticipant.toMap());
  }

  Future<void> insertDiscussionParticipants(
      List<DiscussionParticipant> discussionParticipants) async {
    final db = await _databaseHelper.database;
    final batch = db!.batch();

    for (var discussionParticipant in discussionParticipants) {
      batch.insert('DiscussionParticipant', discussionParticipant.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<int>> getDiscussionParticipantIdsByDiscussionId(
      discussionId) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'DiscussionParticipant',
      where: 'discussion_id = ?',
      whereArgs: [discussionId],
    );
    return List.generate(maps.length, (i) {
      return maps[i]['contact_id'];
    });
  }

  Future<void> removeParticipantsFromDiscussion(
      discussionId, List<int> contactIds) async {
    final db = await _databaseHelper.database;
    final batch = db!.batch();

    for (var contactId in contactIds) {
      batch.delete('DiscussionParticipant',
          where: 'discussion_id = ? AND contact_id = ?',
          whereArgs: [discussionId, contactId]);
    }

    await batch.commit(noResult: true);
  }

  Future<void> deleteAllDiscussionParticipants() async {
    final db = await _databaseHelper.database;
    await db!.delete('DiscussionParticipant');
  }
}
