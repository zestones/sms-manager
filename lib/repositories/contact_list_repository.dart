import 'package:namer_app/models/contact_groups.dart';
import 'package:namer_app/utils/database_helper.dart';

class ContactListRepository {
  final DatabaseHelper _databaseHelper;

  ContactListRepository(this._databaseHelper);

  Future<int> insertContactGroup(ContactGroup contactGroup) async {
    final db = await _databaseHelper.database;
    return await db!.insert('ContactGroups', contactGroup.toMap());
  }

  Future<void> deleteAllContactList() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM ContactGroups');
  }
}
