// GroupSelectionScreen.dart

import 'package:flutter/material.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/models/group.dart';
import 'package:namer_app/service/group_service.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';
import 'package:provider/provider.dart';

class GroupSelectionScreen extends StatefulWidget {
  @override
  GroupSelectionScreenState createState() => GroupSelectionScreenState();
}

class GroupSelectionScreenState extends State<GroupSelectionScreen> {
  List<FilterOption> _filterOptions = [];

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final groupService = Provider.of<GroupService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Select Groups',
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
        backgroundColor: theme.colorScheme.background,
        iconTheme: IconThemeData(color: theme.colorScheme.onBackground),
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
              if (_filterOptions.isEmpty) {
                _filterOptions = List.generate(groups.length, (index) {
                  return FilterOption(groups[index].name);
                });
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: groups.length,
                itemBuilder: (context, index) {
                  final group = groups[index];
                  final filterOption = _filterOptions[index];
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
        // Button to confirm and navigate back
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
