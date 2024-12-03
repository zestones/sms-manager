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
    final fileContent = await File(path).readAsString();
    final lines = LineSplitter().convert(fileContent);

    for (final line in lines) {
      final fields = CsvToListConverter(
        eol: '\n',
        shouldParseNumbers: false,
      ).convert(line).first;

      csvData.add(fields);
      numberLines++;
    }
  }
}
