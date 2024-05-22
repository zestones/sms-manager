import 'package:namer_app/widgets/tri_state_checkbox.dart';

class FilterOption {
  final String groupName;
  TriStateCheckboxState state;

  FilterOption(this.groupName, {this.state = TriStateCheckboxState.checked});
}
