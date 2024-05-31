import 'package:namer_app/models/message.dart';
import 'package:namer_app/repositories/message_repository.dart';

class MessageService {
  final MessageRepository _messageRepository;

  MessageService(this._messageRepository);

  Future<void> insertMessage(Message message) async {
    await _messageRepository.insertMessage(message);
  }

  Future<List<Message>> getAllMessagesByDiscussionId(discussionId) async {
    return await _messageRepository.getAllMessagesByDiscussionId(discussionId);
  }

  Future<void> deleteAllMessages() async {
    await _messageRepository.deleteAllMessages();
  }
}
