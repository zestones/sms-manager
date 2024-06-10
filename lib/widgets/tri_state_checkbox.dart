import 'package:flutter/material.dart';

enum TriCheckboxEnum { unchecked, checked, excluded }

class TriStateCheckbox extends StatefulWidget {
  final TriCheckboxEnum? value;
  final ValueChanged<TriCheckboxEnum?>? onChanged;
  final String title;

  const TriStateCheckbox({
    Key? key,
    this.value,
    this.onChanged,
    required this.title,
  }) : super(key: key);

  @override
  TriStateCheckboxState createState() => TriStateCheckboxState();
}

class TriStateCheckboxState extends State<TriStateCheckbox> {
  TriCheckboxEnum? _state;

  @override
  void initState() {
    super.initState();
    _state = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    Widget checkboxIcon =
        Icon(Icons.check_box_outline_blank, color: theme.primaryColor);

    if (_state == TriCheckboxEnum.checked) {
      checkboxIcon = Icon(Icons.check_box, color: theme.primaryColor);
    } else if (_state == TriCheckboxEnum.excluded) {
      checkboxIcon =
          Icon(Icons.indeterminate_check_box, color: theme.primaryColor);
    }

    return eventDetection(checkboxIcon);
  }

  GestureDetector eventDetection(Widget checkboxIcon) {
    return GestureDetector(
      onTap: () => eventHandler(),
      child: ListTile(
        title: Text(widget.title),
        leading: checkboxIcon,
        onTap: () => eventHandler(),
      ),
    );
  }

  void eventHandler() {
    TriCheckboxEnum? newState;
    switch (_state) {
      case TriCheckboxEnum.checked:
        newState = TriCheckboxEnum.excluded;
        break;
      case TriCheckboxEnum.excluded:
        newState = TriCheckboxEnum.unchecked;
        break;
      case TriCheckboxEnum.unchecked:
        newState = TriCheckboxEnum.checked;
        break;
      case null:
        newState = TriCheckboxEnum.unchecked;
        break;
    }
    setState(() {
      _state = newState;
      if (widget.onChanged != null) {
        widget.onChanged!(newState);
      }
    });
  }
}
