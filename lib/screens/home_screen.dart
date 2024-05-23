import 'package:flutter/material.dart';
import 'package:namer_app/screens/add_discussion_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Discussions',
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final discussionName = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDiscussionScreen()),
          );

          if (discussionName != null) {
            // TODO: Handle the created discussion name
            print('New discussion created: $discussionName');
          }
        },
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary, size: 40.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Center(
        child: Text(
          'Discussion List will be shown here',
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
      ),
    );
  }
}
