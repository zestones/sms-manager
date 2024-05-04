class Person {
  String firstName;
  String lastName;
  String phoneNumber;
  List<String> categories;

  Person({
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.categories,
  });

  factory Person.fromCsv(List<dynamic> csvData) {
    return Person(
      firstName: csvData[0],
      lastName: csvData[1],
      phoneNumber: csvData[2],
      categories: (csvData[3] as String)
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(','),
    );
  }
}
