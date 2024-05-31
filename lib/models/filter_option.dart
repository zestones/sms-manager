import 'package:namer_app/widgets/tri_state_checkbox.dart';

class FilterOption {
  final int? id;
  final String name;
  TriCheckboxEnum state;

  FilterOption(this.name, this.id, {this.state = TriCheckboxEnum.unchecked});
}
