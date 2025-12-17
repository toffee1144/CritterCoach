import 'package:flutter/material.dart';
import '../../domain/entities/message.dart';

class ChatBotBubble extends StatelessWidget {
  final Message m;
  const ChatBotBubble(this.m, {super.key});

  @override
  Widget build(BuildContext context) {
    final isBot = m.sender == Sender.bot;
    final bg = isBot ? const Color(0xFFFFDA27) : const Color(0xFFDDE6F4);
    final align = isBot ? Alignment.centerLeft : Alignment.centerRight;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(12),
      topRight: const Radius.circular(12),
      bottomLeft: Radius.circular(isBot ? 4 : 12),
      bottomRight: Radius.circular(isBot ? 12 : 4),
    );

    return Align(
      alignment: align,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.8,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: bg, borderRadius: radius),
          child: Text(
            m.text,
            style: const TextStyle(
              fontSize: 16,
              height: 1.3,
              color: Color(0xFF1B1E28),
            ),
          ),
        ),
      ),
    );
  }
}
