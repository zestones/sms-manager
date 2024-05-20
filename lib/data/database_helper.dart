import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database>? database;

  static Future<void> initializeDatabase() async {
    database = openDatabase(
      join(await getDatabasesPath(), 'contact_list.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
            CREATE TABLE Contact (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              first_name TEXT NOT NULL,
              last_name TEXT NOT NULL,
              phone_number TEXT NOT NULL UNIQUE
            );
          ''',
        );

        await db.execute(
          '''
            CREATE TABLE Groups (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE
            );
          ''',
        );

        await db.execute(
          '''
            CREATE TABLE ContactGroups (
              contact_id INTEGER,
              group_id INTEGER,
              PRIMARY KEY (contact_id, group_id),
              FOREIGN KEY (contact_id) REFERENCES Contact(id),
              FOREIGN KEY (group_id) REFERENCES Groups(id)
            );
          ''',
        );
      },
      version: 1,
    );
  }
}
