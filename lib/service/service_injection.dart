import 'package:namer_app/repositories/contact_list_repository.dart';
import 'package:namer_app/repositories/contact_repository.dart';
import 'package:namer_app/repositories/discussion_participant_repository.dart';
import 'package:namer_app/repositories/discussion_repository.dart';
import 'package:namer_app/repositories/group_repository.dart';
import 'package:namer_app/service/contact_list_service.dart';
import 'package:namer_app/service/contact_service.dart';
import 'package:namer_app/service/discussion_service.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:namer_app/service/load_csv_contact_list_service.dart';
import 'package:namer_app/utils/database_helper.dart';

import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

class ServiceInjection {
  static List<SingleChildWidget> inject(DatabaseHelper databaseHelper) {
    return [
      // initialize the repositories
      ..._injectRepositories(databaseHelper),

      // Initialize the services, depending on repositories
      ..._injectServices(),
    ];
  }

  static List<SingleChildWidget> _injectRepositories(
      DatabaseHelper databaseHelper) {
    return [
      Provider<ContactListRepository>(
          create: (_) => ContactListRepository(databaseHelper)),
      Provider<ContactRepository>(
          create: (_) => ContactRepository(databaseHelper)),
      Provider<GroupRepository>(create: (_) => GroupRepository(databaseHelper)),
      Provider<DiscussionRepository>(
          create: (_) => DiscussionRepository(databaseHelper)),
      Provider<DiscussionParticipantRepository>(
          create: (_) => DiscussionParticipantRepository(databaseHelper)),
    ];
  }

  static List<SingleChildWidget> _injectServices() {
    return [
      ProxyProvider<ContactListRepository, ContactListService>(
        update: (context, contactListRepository, _) =>
            ContactListService(contactListRepository),
      ),
      ProxyProvider<ContactRepository, ContactService>(
        update: (context, contactRepository, _) =>
            ContactService(contactRepository),
      ),
      ProxyProvider<GroupRepository, GroupService>(
        update: (context, groupRepository, _) => GroupService(groupRepository),
      ),
      ProxyProvider3<ContactListRepository, ContactRepository, GroupRepository,
          LoadCSVContactListService>(
        update: (
          context,
          contactListRepository,
          contactRepository,
          groupRepository,
          _,
        ) =>
            LoadCSVContactListService(
          contactListRepository,
          contactRepository,
          groupRepository,
        ),
      ),
      ProxyProvider3<DiscussionRepository, ContactListRepository,
          DiscussionParticipantRepository, DiscussionService>(
        update: (context, discussionRepository, contactListRepository,
                discussionParticipantRepository, _) =>
            DiscussionService(
          discussionRepository,
          contactListRepository,
          discussionParticipantRepository,
        ),
      ),
    ];
  }
}
