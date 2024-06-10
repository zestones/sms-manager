import 'package:namer_app/models/contact.dart';
import 'package:namer_app/utils/database_helper.dart';

class ContactRepository {
  final DatabaseHelper _databaseHelper;

  ContactRepository(this._databaseHelper);

  Future<Contact> getContactById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query(
      'Contact',
      where: 'id = ?',
      whereArgs: [id],
    );
    return Contact(
      id: maps[0]['id'],
      firstName: maps[0]['first_name'],
      lastName: maps[0]['last_name'],
      phoneNumber: maps[0]['phone_number'],
    );
  }

  Future<int> insertContact(Contact contact) async {
    final db = await _databaseHelper.database;
    return await db!.insert('Contact', contact.toMap());
  }

  Future<List<Contact>> getAllContact() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db!.query('Contact');
    return List.generate(maps.length, (i) {
      return Contact(
        id: maps[i]['id'],
        firstName: maps[i]['first_name'],
        lastName: maps[i]['last_name'],
        phoneNumber: maps[i]['phone_number'],
      );
    });
  }

  Future<void> deleteAllContact() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM Contact');
  }
}
