import 'package:namer_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class BackupRepository {
  final DatabaseHelper _databaseHelper;

  BackupRepository(this._databaseHelper);

  // GETTERS

  Future<List<Map<String, dynamic>>> getAllContacts() async {
    final db = await _databaseHelper.database;
    return await db!.query('Contact');
  }

  Future<List<Map<String, dynamic>>> getAllGroups() async {
    final db = await _databaseHelper.database;
    return await db!.query('Groups');
  }

  Future<List<Map<String, dynamic>>> getAllContactGroups() async {
    final db = await _databaseHelper.database;
    return await db!.query('ContactGroups');
  }

  Future<List<Map<String, dynamic>>> getAllMessages() async {
    final db = await _databaseHelper.database;
    return await db!.query('Message');
  }

  Future<List<Map<String, dynamic>>> getAllDiscussions() async {
    final db = await _databaseHelper.database;
    return await db!.query('Discussion');
  }

  Future<List<Map<String, dynamic>>> getAllDiscussionParticipants() async {
    final db = await _databaseHelper.database;
    return await db!.query('DiscussionParticipant');
  }

  // INSERTS
  Future<void> insertAll(Map<String, dynamic> dump) async {
    final db = await _databaseHelper.database;
    await db!.transaction((txn) async {
      try {
        await insertContacts(
            txn, List<Map<String, dynamic>>.from(dump['contacts']));
        await insertGroups(
            txn, List<Map<String, dynamic>>.from(dump['groups']));
        await insertContactGroups(
            txn, List<Map<String, dynamic>>.from(dump['contactGroups']));
        await insertDiscussions(
            txn, List<Map<String, dynamic>>.from(dump['discussions']));
        await insertMessages(
            txn, List<Map<String, dynamic>>.from(dump['messages']));
        await insertDiscussionParticipants(txn,
            List<Map<String, dynamic>>.from(dump['discussionParticipants']));
      } catch (e) {
        print('Error importing data: $e');
        rethrow;
      }
    });
  }

  Future<void> insertContacts(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('Contact', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertGroups(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('Groups', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertContactGroups(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('ContactGroups', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertDiscussions(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('Discussion', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertMessages(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('Message', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<void> insertDiscussionParticipants(
      Transaction txn, List<Map<String, dynamic>> rows) async {
    for (var row in rows) {
      await txn.insert('DiscussionParticipant', row,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
