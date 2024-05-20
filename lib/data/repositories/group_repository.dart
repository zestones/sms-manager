// import 'package:sqflite/sqflite.dart';

// import '../../models/group.dart';
// import '../database_helper.dart';

// class GroupRepository {
//   static Future<void> insertGroup(Group group) async {
//     final Database db = await DatabaseHelper.database!;
//     await db.insert(
//       'Group',
//       group.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   static Future<List<Group>> getAllGroups() async {
//     final Database db = await DatabaseHelper.database!;
//     final List<Map<String, dynamic>> maps = await db.query('Group');
//     return List.generate(maps.length, (i) {
//       return Group.fromMap(maps[i]);
//     });
//   }
// }
