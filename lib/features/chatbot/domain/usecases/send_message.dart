import '../entities/message.dart';
import '../repositories/chatbot_repository.dart';
class SendMessage {
final ChatBotRepository repo;
SendMessage(this.repo);
Future<Message> call(
String text, {
List<Message> history = const [],
}) =>
repo.getReply(text, history: history);
}
