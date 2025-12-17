// chatbot_repository.dart
import '../entities/message.dart';
abstract class ChatBotRepository {
  Future<Message> getReply(
  String userText, {
    List<Message> history = const [],
  });
}
