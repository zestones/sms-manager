import 'package:namer_app/models/group.dart';
import 'package:namer_app/repositories/group_repository.dart';

class GroupService {
  final GroupRepository _contactRepository;

  GroupService(this._contactRepository);

  Future<void> insertGroup(Group group) async {
    await _contactRepository.insertGroup(group);
  }

  Future<List<Group>> getAllGroup() async {
    return await _contactRepository.getAllGroup();
  }

  Future<void> deleteAllGroup() async {
    await _contactRepository.deleteAllGroup();
  }
}
