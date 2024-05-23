import 'package:flutter/material.dart';
import 'package:namer_app/models/filter_option.dart';
import 'package:namer_app/screens/group_selection_screen.dart';
import 'package:namer_app/widgets/large_ink_well_button.dart';
import 'package:namer_app/widgets/tri_state_checkbox.dart';

class AddDiscussionScreen extends StatefulWidget {
  @override
  AddDiscussionScreenState createState() => AddDiscussionScreenState();
}

class AddDiscussionScreenState extends State<AddDiscussionScreen> {
  final TextEditingController _discussionNameController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List<FilterOption> _filterOptions = [];
  bool isSearchBarFocused = false;

  void _createDiscussion(BuildContext context) {
    String discussionName = _discussionNameController.text.trim();
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

    if (selectedGroups != null) {
      setState(() {
        _filterOptions = selectedGroups;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    double searchBarTopPosition = isSearchBarFocused ? 0 : 150;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nouvelle Discussion',
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _createDiscussion(context),
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            child: Text('Créer'),
          ),
        ],
      ),
      body: Stack(
        children: [
          AnimatedOpacity(
            opacity: isSearchBarFocused ? 0.0 : 1.0,
            duration: Duration(milliseconds: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  width: double.infinity,
                  child: TextField(
                    controller: _discussionNameController,
                    decoration: InputDecoration(
                      labelText: 'Nom de la discussion',
                      focusColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
                LargeInkWellButton(
                  theme: theme,
                  title: "Select Groups",
                  subtitle:
                      "Select groups to include or exclude in the discussion",
                  callback: () => _navigateToGroupSelection(context),
                ),
                SizedBox(height: 10),
                if (_filterOptions.isNotEmpty) displaySelectedGroups(),
              ],
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: searchBarTopPosition,
            left: 0,
            right: 0,
            child: SearchBar(
              controller: _searchController,
              hintText: 'Rechercher des contacts',
              onChanged: (value) {},
              onFocusChange: (value) {
                print('Search bar focused: $value');
                setState(() {
                  isSearchBarFocused = value;
                });
              },
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            top: searchBarTopPosition + 40,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Suggestions',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.secondary,
                  fontSize: 12.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column displaySelectedGroups() {
    return Column(
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
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;
  final Function(bool) onFocusChange;

  const SearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onFocusChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Focus(
      onFocusChange: onFocusChange,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        height: 40.0,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          border: Border.all(color: theme.colorScheme.onBackground),
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onTap: () => onFocusChange(true),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: theme.colorScheme.secondary),
            border: InputBorder.none,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 1.0),
            suffixIcon: Icon(Icons.search, color: theme.colorScheme.secondary),
          ),
          style: TextStyle(color: theme.colorScheme.onBackground),
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
