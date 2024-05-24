import 'package:namer_app/widgets/tri_state_checkbox.dart';

class FilterOption {
  final int? id;
  final String groupName;
  TriCheckboxEnum state;

  FilterOption(this.groupName, this.id, {this.state = TriCheckboxEnum.checked});
}
