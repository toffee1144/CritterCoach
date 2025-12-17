import '../../domain/entities/message.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chatbot_remote_ds.dart';
class ChatBotRepositoryImpl implements ChatBotRepository {
    
  final ChatBotRemoteDataSource remote;
  ChatBotRepositoryImpl(this.remote);

  @override
  Future<Message> getReply(
    String userText, {
    List<Message> history = const [],
    }) {
      return remote.getBotReply(userText, history: history);
    }
}
