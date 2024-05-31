import 'package:flutter/material.dart';
import 'package:namer_app/models/discussion.dart';
import 'package:namer_app/models/message.dart';
import 'package:namer_app/service/message_service.dart';
import 'package:provider/provider.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({
    super.key,
    required this.discussion,
  });

  final Discussion discussion;

  @override
  DiscussionScreenState createState() => DiscussionScreenState();
}

class DiscussionScreenState extends State<DiscussionScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  void _loadMessages() {
    final messageService = Provider.of<MessageService>(context, listen: false);
    messageService.getAllMessagesByDiscussionId(widget.discussion.id!).then(
      (messages) {
        setState(() {
          _messages.clear();
          _messages.addAll(messages);
        });
      },
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final messageService =
          Provider.of<MessageService>(context, listen: false);
      setState(() {
        Message message = Message(
          discussionId: widget.discussion.id!,
          text: _controller.text,
        );

        // TODO: Send SMS to all participants
        messageService.insertMessage(message);
        _messages.add(message);

        _controller.clear();

        // Scroll to the bottom of the list
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.discussion.name,
          style: TextStyle(color: theme.colorScheme.onBackground),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          buildMessageInputField(theme),
        ],
      ),
    );
  }

  Container buildMessageInputField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 20.0),
                hintText: 'Écrivez un message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.tertiary,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            radius: 25.0,
            backgroundColor: theme.colorScheme.primary,
            child: IconButton(
              icon: Icon(Icons.send, color: theme.colorScheme.onPrimary),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.8),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
                bottomLeft: Radius.circular(12.0),
                bottomRight: Radius.circular(0.0),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: theme.colorScheme.onPrimary),
            ),
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          message.formatTimestamp(),
          style: TextStyle(
            color: theme.colorScheme.onBackground,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}
