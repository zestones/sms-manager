import 'package:flutter/material.dart';

enum TriStateCheckboxState { unchecked, checked, excluded }

class TriStateCheckbox extends StatefulWidget {
  final TriStateCheckboxState? value;
  final ValueChanged<TriStateCheckboxState?>? onChanged;
  final String title;

  const TriStateCheckbox({
    Key? key,
    this.value,
    this.onChanged,
    required this.title,
  }) : super(key: key);

  @override
  _TriStateCheckboxState createState() => _TriStateCheckboxState();
}

class _TriStateCheckboxState extends State<TriStateCheckbox> {
  TriStateCheckboxState? _state;

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

    if (_state == TriStateCheckboxState.checked) {
      checkboxIcon = Icon(Icons.check_box, color: theme.primaryColor);
    } else if (_state == TriStateCheckboxState.excluded) {
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
    TriStateCheckboxState? newState;
    switch (_state) {
      case TriStateCheckboxState.checked:
        newState = TriStateCheckboxState.unchecked;
        break;
      case TriStateCheckboxState.unchecked:
        newState = TriStateCheckboxState.excluded;
        break;
      case TriStateCheckboxState.excluded:
        newState = TriStateCheckboxState.checked;
        break;
      case null:
        newState = TriStateCheckboxState.unchecked;
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
