import 'package:namer_app/models/group.dart';
import 'package:namer_app/utils/database_helper.dart';

class GroupRepository {
  final DatabaseHelper _databaseHelper;

  GroupRepository(this._databaseHelper);

  Future<int> insertGroup(Group group) async {
    final db = await _databaseHelper.database;
    return await db!.insert('Groups', group.toMap());
  }

  Future<Group?> getGroupByName(String name) async {
    final db = await _databaseHelper.database;
    final maps =
        await db!.query('Groups', where: 'name = ?', whereArgs: [name]);

    if (maps.isEmpty) {
      return null;
    }

    return Group.fromMap(maps.first);
  }

  Future<void> deleteAllGroup() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM Groups');
  }
}
