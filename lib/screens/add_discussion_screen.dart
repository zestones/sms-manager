import 'package:flutter/material.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/screens/group_selection_screen.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';

class AddDiscussionScreen extends StatefulWidget {
  @override
  AddDiscussionScreenState createState() => AddDiscussionScreenState();
}

class AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final TextEditingController _controller = TextEditingController();
  List<FilterOption> _filterOptions = [];

  void _createDiscussion(BuildContext context) {
    String discussionName = _controller.text.trim();
    if (discussionName.isNotEmpty && _filterOptions.isNotEmpty) {
      // TODO: Using discussion service to insert in the database
      Navigator.pop(
          context, {'name': discussionName, 'groups': _filterOptions});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Le nom de la discussion et les groupes sont requis'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToGroupSelection(BuildContext context) async {
    final selectedGroups = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GroupSelectionScreen()),
    );

    for (var option in _filterOptions) {
      print("${option.groupName} - ${option.state}");
    }

    if (selectedGroups != null) {
      setState(() {
        _filterOptions = selectedGroups;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Discussion',
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: theme.colorScheme.background,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Discussion Name'),
            ),
            SizedBox(height: 20),
            Text('Groupes sélectionnés: ${_filterOptions.length}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            if (_filterOptions.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Wrap(
                      spacing: 10,
                      children: _filterOptions.map((option) {
                        return GroupChip(
                            option: option,
                            onDelete: (option) {
                              print('Removed ${option.groupName}');
                              setState(() {
                                _filterOptions.remove(option);
                              });
                            });
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              // Button to navigate to group selection page
              onPressed: () => _navigateToGroupSelection(context),
              child: Text('Select Groups'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _createDiscussion(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              child: Text('Create', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class GroupChip extends StatelessWidget {
  const GroupChip({
    Key? key,
    required this.option,
    required this.onDelete,
  }) : super(key: key);

  final FilterOption option;
  final Function(FilterOption) onDelete;

  @override
  Widget build(BuildContext context) {
    var color = (option.state == TriCheckboxEnum.checked)
        ? Colors.blue
        : (option.state == TriCheckboxEnum.excluded)
            ? Colors.orange
            : Colors.red;
    return InputChip(
      label: Text(option.groupName, style: TextStyle(color: color)),
      onDeleted: () => onDelete(option),
      deleteIconColor: color,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
        side: BorderSide(color: color),
      ),
    );
  }
}
