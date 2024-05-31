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

  Future<void> deleteAllDiscussionParticipants() async {
    final db = await _databaseHelper.database;
    await db!.delete('DiscussionParticipant');
  }
}
