import 'package:flutter/material.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/models/group.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';
import 'package:provider/provider.dart';

class GroupSelectionScreen extends StatefulWidget {
  final List<FilterOption> filterOptions;

  GroupSelectionScreen({required this.filterOptions});

  @override
  GroupSelectionScreenState createState() => GroupSelectionScreenState();
}

class GroupSelectionScreenState extends State<GroupSelectionScreen> {
  late List<FilterOption> _filterOptions;

  @override
  void initState() {
    super.initState();
    _filterOptions = List.from(widget.filterOptions);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final groupService = Provider.of<GroupService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajouts de groupes',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Group>>(
          future: groupService.getAllGroup(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final groups = snapshot.data!;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  _filterOptions = groups.map((group) {
                    final filterOption = _filterOptions.firstWhere(
                      (option) => option.id == group.id,
                      orElse: () => FilterOption(group.name, group.id),
                    );
                    return filterOption;
                  }).toList();

                  final filterOption = _filterOptions.firstWhere(
                    (option) => option.id == group.id,
                    orElse: () => FilterOption(group.name, group.id),
                  );
                  return TriStateCheckbox(
                    title: group.name,
                    value: filterOption.state,
                    onChanged: (state) => _filterOptions[index].state = state!,
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _filterOptions.removeWhere(
              (option) => option.state == TriCheckboxEnum.unchecked);
          Navigator.pop(context, _filterOptions);
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
