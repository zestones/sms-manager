import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/utils/database_helper.dart';

class DiscussionRepository {
  final DatabaseHelper _databaseHelper;

  DiscussionRepository(this._databaseHelper);

  Future<int> insertDiscussion(Discussion discussion) async {
    final db = await _databaseHelper.database;
    return await db!.insert('Discussion', discussion.toMap());
  }

  Future<List<Discussion>> getAllDiscussion() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query('Discussion');
    return List.generate(maps.length, (i) {
      return Discussion(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> deleteAllDiscussion() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM Discussion');
  }
}
