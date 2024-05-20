// import 'package:sqflite/sqflite.dart';

// import '../../models/contact.dart';
// import '../database_helper.dart';

// class ContactRepository {
//   static Future<void> insertPerson(Contact contact) async {
//     final Database db = await DatabaseHelper.database!;
//     await db.insert(
//       'Contact',
//       contact.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<Contact>> getAllPersons() async {
//     final Database db = await DatabaseHelper.database!;
//     final List<Map<String, dynamic>> maps = await db.query('Contact');
//     return List.generate(maps.length, (i) {
//       return Contact.fromMap(maps[i]);
//     });
//   }
// }
