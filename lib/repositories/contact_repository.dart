import 'package:namer_app/models/contact.dart';
import 'package:namer_app/utils/database_helper.dart';

class ContactRepository {
  final DatabaseHelper _databaseHelper;

  ContactRepository(this._databaseHelper);

  Future<int> insertContact(Contact contact) async {
    final db = await _databaseHelper.database;
    return await db!.insert('Contact', contact.toMap());
  }

  Future<void> deleteAllContact() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM Contact');
  }
}
