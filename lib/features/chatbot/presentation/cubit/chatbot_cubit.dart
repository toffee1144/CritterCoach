import 'package:bloc/bloc.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/entities/message.dart';
import 'chatbot_state.dart';
class ChatBotCubit extends Cubit<ChatBotState> {
  final SendMessage sendMessage;
  
  ChatBotCubit(this.sendMessage) : super(const ChatBotState());

  Future<void> send(String text) async {
    final t = text.trim();
    if (t.isEmpty) return;
    final user = Message(
      id: "u_${DateTime.now().microsecondsSinceEpoch}",
      text: t,
      ts: DateTime.now(),
      sender: Sender.user,
    );

    final withUser = List<Message>.from(state.messages)..add(user);
    emit(state.copyWith(messages: withUser, sending: true, introVisible: false));

    try {
      final bot = await sendMessage(
        t,
        history: withUser,
      );

      final updated = List<Message>.from(withUser)..add(bot);
      emit(state.copyWith(messages: updated, sending: false, introVisible: false));
    } catch (e) {
      final fallback = Message(
        id: "b_${DateTime.now().microsecondsSinceEpoch}",
        text: "Sorry, I can’t reply right now. Try again.",
        ts: DateTime.now(),
        sender: Sender.bot,
      );
      final updated = List<Message>.from(withUser)..add(fallback);
      emit(state.copyWith(messages: updated, sending: false, introVisible: false));
    }
  }
}
