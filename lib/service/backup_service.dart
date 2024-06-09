import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:namer_app/repositories/backup_repository.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class BackupService {
  final BackupRepository _backupRepository;
  static const String defaultExternalPath =
      '/storage/emulated/0/Download/SMSManager';

  BackupService(this._backupRepository);

  Future<String> getExternalDocumentPath() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    Directory directory = Directory("dir");
    if (Platform.isAndroid) {
      directory = Directory(defaultExternalPath);
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final exPath = directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  Future<String> get localPath async {
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  Future<bool> export(String path) async {
    Map<String, dynamic> dump = {};

    dump['contacts'] = await _backupRepository.getAllContacts();
    dump['groups'] = await _backupRepository.getAllGroups();
    dump['contactGroups'] = await _backupRepository.getAllContactGroups();
    dump['discussions'] = await _backupRepository.getAllDiscussions();
    dump['messages'] = await _backupRepository.getAllMessages();
    dump['discussionParticipants'] =
        await _backupRepository.getAllDiscussionParticipants();

    try {
      String timestamp =
          DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now());

      String fileName = 'backup_$timestamp.json';
      String filePath = join(await localPath, fileName);
      File file = File(filePath);

      // If the file exists, delete it before writing the new data
      if (await file.exists()) await file.delete();
      await file.writeAsString(jsonEncode(dump));

      return true;
    } catch (e) {
      print('Error exporting data: $e');
      return false;
    }
  }

  Future<bool> import(String filePath) async {
    final File file = File(filePath);
    final String content = await file.readAsString();

    final Map<String, dynamic> dump =
        Map<String, dynamic>.from(jsonDecode(content));

    // print the dump
    print(dump['contacts']);
    print("=====================================");
    print(dump['groups']);
    print(dump['contactGroups']);
    print(dump['discussions']);
    print(dump['messages']);
    print(dump['discussionParticipants']);

    try {
      await _backupRepository.insertAll(dump);
      return true;
    } catch (e) {
      print('Error importing data: $e');
      return false;
    }
  }
}
