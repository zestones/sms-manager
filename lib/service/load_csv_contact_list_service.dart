import 'package:namer_app/models/contact.dart';
import 'package:namer_app/models/contact_groups.dart';
import 'package:namer_app/models/group.dart';
import 'package:namer_app/repositories/contact_list_repository.dart';
import 'package:namer_app/repositories/contact_repository.dart';
import 'package:namer_app/repositories/group_repository.dart';
import 'package:namer_app/service/local_notification_service.dart';
import 'package:namer_app/utils/csv_helper.dart';

class LoadCSVContactListService {
  final ContactListRepository _contactListRepository;
  final ContactRepository _contactRepository;
  final GroupRepository _groupRepository;

  LoadCSVContactListService(this._contactListRepository,
      this._contactRepository, this._groupRepository);

  Future<void> call(String path) async {
    final csvHelper = CsvHelper(path: path);
    await csvHelper.readCsv();

    print('Number of lines: ${csvHelper.numberLines}');

    for (var i = 1; i < csvHelper.numberLines; i++) {
      final firstName = csvHelper.csvData[i][0];
      final lastName = csvHelper.csvData[i][1];
      final phoneNumber = csvHelper.csvData[i][2];
      final categories = csvHelper.csvData[i][3]
          .replaceAll('[', '')
          .replaceAll(']', '')
          .split(',');

      // Insert or retrieve contacts
      final contact = Contact(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phoneNumber,
      );

      final contactId = await _contactRepository.insertContact(contact);
      print('Contact inserted with id: $contactId');

      // Associate contacts with groups/categories
      for (var category in categories) {
        final group = await _groupRepository.getGroupByName(category);

        int groupId;
        if (group == null) {
          final newGroup = Group(name: category);
          groupId = await _groupRepository.insertGroup(newGroup);
        } else {
          groupId = group.id!;
        }
        await _contactListRepository.insertContactGroup(
            ContactGroup(contactId: contactId, groupId: groupId));
      }

      await LocalNotificationService.showProgressNotification(
        title: 'Importation des contacts',
        body:
            'Progression: ${(i / csvHelper.numberLines * 100).toStringAsFixed(0)}%',
        progress: i,
        maxProgress: csvHelper.numberLines,
      );
    }
  }
}
