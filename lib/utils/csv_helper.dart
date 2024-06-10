import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:io';

class CsvHelper {
  String path;
  List<List<dynamic>> csvData = [];
  int numberLines = 0;

  CsvHelper({required this.path}) {
    if (!File(path).existsSync()) {
      throw Exception('File does not exist');
    }
  }

  Future<void> readCsv() async {
    final input = File(path).openRead();

    await input.transform(utf8.decoder).transform(CsvToListConverter()).forEach(
      (dynamic fields) {
        csvData.add(fields);
      },
    );

    numberLines = csvData.length;
  }
}
