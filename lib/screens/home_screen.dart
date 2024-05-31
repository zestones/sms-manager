import 'package:flutter/material.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/screens/add_discussion_screen.dart';
import 'package:namer_app/screens/discussion_screen.dart';
import 'package:namer_app/service/discussion_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Discussion> discussions = [];

  @override
  void initState() {
    super.initState();
    _loadDiscussions();
  }

  void _loadDiscussions() async {
    final discussionService =
        Provider.of<DiscussionService>(context, listen: false);
    final discussions = await discussionService.getAllDiscussion();
    setState(() => this.discussions = discussions);
  }

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
          final obj = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDiscussionScreen()),
          );

          if (obj['name'] != null && obj['id'] != null) {
            setState(() =>
                discussions.add(Discussion(id: obj['id'], name: obj['name'])));
          }
        },
        backgroundColor: theme.colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(Icons.add, color: theme.colorScheme.onPrimary, size: 40.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: discussions.isEmpty
            ? Center(
                child: Text(
                  'No discussions yet',
                  style: TextStyle(
                    color: theme.colorScheme.onBackground,
                    fontSize: 18.0,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: discussions.length,
                itemBuilder: (context, index) {
                  final discussion = discussions[index];
                  return DiscussionTile(discussion: discussion);
                },
              ),
      ),
    );
  }
}

class DiscussionTile extends StatelessWidget {
  const DiscussionTile({
    super.key,
    required this.discussion,
  });

  final Discussion discussion;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.all(16.0),
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              discussion.name[0],
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
          title: Text(
            discussion.name,
            style: TextStyle(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios,
              color: theme.colorScheme.onBackground),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiscussionScreen(discussion: discussion),
              ),
            );
          },
          tileColor: theme.colorScheme.tertiary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
