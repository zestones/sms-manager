import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  Future<Database>? database;
  String databaseName = 'contact_list.db';

  Future<void> init() async {
    database = openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) async {
        await db.execute(
          '''
            CREATE TABLE Contact (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              first_name TEXT NOT NULL,
              last_name TEXT NOT NULL,
              phone_number TEXT NOT NULL
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

        await db.execute(
          '''
            CREATE TABLE Discussion (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL UNIQUE
            );
          ''',
        );

        await db.execute(
          '''
            CREATE TABLE Message (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              discussion_id INTEGER NOT NULL,
              text TEXT NOT NULL,
              timestamp TEXT NOT NULL,
              FOREIGN KEY (discussion_id) REFERENCES Chat(id)
            );
          ''',
        );

        await db.execute(
          '''
            CREATE TABLE DiscussionParticipant (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              contact_id INTEGER NOT NULL,
              discussion_id INTEGER NOT NULL,
              FOREIGN KEY (contact_id) REFERENCES Contact(id),
              FOREIGN KEY (discussion_id) REFERENCES Chat(id),
              UNIQUE (contact_id, discussion_id)
            );
          ''',
        );
      },
      version: 1,
    );
  }

  Future<void> clearAllTables() async {
    final db = await database;
    await db?.execute('DELETE FROM ContactGroups');
    await db?.execute('DELETE FROM Contact');
    await db?.execute('DELETE FROM Group');
  }

  Future<void> close() async {
    final db = await database;
    db!.close();
  }

  Future<String> getDatabasePath() async {
    return join(await getDatabasesPath(), 'contact_list.db');
  }
}
