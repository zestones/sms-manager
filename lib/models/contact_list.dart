import 'person.dart';

class ContactList {
  List<Person> persons;

  ContactList(this.persons);

  factory ContactList.fromCsvList(List<List<dynamic>> csvDataList) {
    List<Person> persons =
        csvDataList.map((csvData) => Person.fromCsv(csvData)).toList();
    return ContactList(persons);
  }

  List<String> getCategories() {
    Set<String> categorySet = {};
    for (var person in persons) {
      categorySet.addAll(person.categories);
    }
    return categorySet.toList();
  }

  void clear() {
    persons.clear();
  }
}
