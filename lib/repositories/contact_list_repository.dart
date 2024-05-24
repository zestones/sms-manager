import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/contact_groups.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/utils/database_helper.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';

class ContactListRepository {
  final DatabaseHelper _databaseHelper;

  ContactListRepository(this._databaseHelper);

  Future<int> insertContactGroup(ContactGroup contactGroup) async {
    final db = await _databaseHelper.database;
    return await db!.insert('ContactGroups', contactGroup.toMap());
  }

  Future<List<Contact>> getContactsByGroups(
      List<FilterOption> filterOptions) async {
    final db = await _databaseHelper.database;

    String query = '''
      SELECT DISTINCT c.* 
      FROM Contact c
      JOIN ContactGroups cg ON c.id = cg.contact_id
      JOIN Groups g ON cg.group_id = g.id
      WHERE 1=1
    ''';

    List<dynamic> arguments = [];

    List<String> checkedGroupNames = [];
    List<String> excludedGroupNames = [];

    for (var option in filterOptions) {
      if (option.state == TriCheckboxEnum.checked) {
        checkedGroupNames.add(option.name);
      } else if (option.state == TriCheckboxEnum.excluded) {
        excludedGroupNames.add(option.name);
      }
    }

    if (checkedGroupNames.isNotEmpty) {
      query +=
          ' AND g.name IN (${List.filled(checkedGroupNames.length, '?').join(',')})';
      arguments.addAll(checkedGroupNames);
    }

    if (excludedGroupNames.isNotEmpty) {
      query += ' AND c.id NOT IN (';
      query += ' SELECT c.id';
      query += ' FROM Contact c';
      query += ' JOIN ContactGroups cg ON c.id = cg.contact_id';
      query += ' JOIN Groups g ON cg.group_id = g.id';
      query +=
          ' WHERE g.name IN (${List.filled(excludedGroupNames.length, '?').join(',')})';
      query += ' )';
      arguments.addAll(excludedGroupNames);
    }

    List<Map<String, dynamic>> result = await db!.rawQuery(query, arguments);

    List<Contact> contacts = [];
    for (var row in result) {
      contacts.add(Contact.fromMap(row));
    }

    return contacts;
  }

  Future<void> deleteAllContactList() async {
    final db = await _databaseHelper.database;
    await db!.execute('DELETE FROM ContactGroups');
  }
}
