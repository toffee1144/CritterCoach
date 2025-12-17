import '../../domain/entities/message.dart';

abstract class ChatBotRemoteDataSource {
Future<Message> getBotReply(
String userText, {
List<Message> history = const [],
});
}
