import 'package:equatable/equatable.dart';
import '../../domain/entities/message.dart';

class ChatBotState extends Equatable {
  final List<Message> messages;
  final bool sending;
  /// Show intro (icon + title) until the first user message.
  final bool introVisible;

  const ChatBotState({
    this.messages = const [],
    this.sending = false,
    this.introVisible = true,
  });

  ChatBotState copyWith({
    List<Message>? messages,
    bool? sending,
    bool? introVisible,
  }) {
    return ChatBotState(
      messages: messages ?? this.messages,
      sending: sending ?? this.sending,
      introVisible: introVisible ?? this.introVisible,
    );
  }

  @override
  List<Object?> get props => [messages, sending, introVisible];
}
