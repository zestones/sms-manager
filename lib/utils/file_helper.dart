// import 'dart:io';

// import '../models/contact_list.dart';

// class FileHelper {
//   static String getFileName(String path) {
//     return path.split('/').last;
//   }

//   static List<String> _readLines(String filePath) {
//     try {
//       File file = File(filePath);
//       return file.readAsLinesSync();
//     } catch (e) {
//       print('Error reading file: $e');
//       return [];
//     }
//   }

//   static ContactList getContactList(String filePath) {
//     List<String> lines = _readLines(filePath);
//     List<List<dynamic>> csvDataList = [];

//     for (var i = 1; i < lines.length; i++) {
//       var line = lines[i];
//       List<dynamic> csvData = line.split(',');
//       csvDataList.add(csvData);
//     }

//     return ContactList.fromCsvList(csvDataList);
//   }
// }
