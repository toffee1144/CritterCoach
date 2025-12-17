import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/chatbot_bubble.dart';
import '../../../../di/injector.dart';
import '../cubit/chatbot_cubit.dart';
import '../cubit/chatbot_state.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatBotCubit(sl()),
      child: const _ChatScaffold(),
    );
  }
}

class _ChatScaffold extends StatefulWidget {
  const _ChatScaffold();

  @override
  State<_ChatScaffold> createState() => _ChatScaffoldState();
}

class _ChatScaffoldState extends State<_ChatScaffold> {
  final _c = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _c.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1B1E28),
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text(
          'AI Chatbot',
          style: TextStyle(
            color: Color(0xFF1B1E28),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBotCubit, ChatBotState>(
                listener: (context, state) {
                  if (state.messages.isNotEmpty &&
                      _scroll.hasClients) {
                    Future.delayed(
                      const Duration(milliseconds: 60),
                      () {
                        _scroll.animateTo(
                          _scroll.position.maxScrollExtent,
                          duration:
                              const Duration(milliseconds: 240),
                          curve: Curves.easeOut,
                        );
                      },
                    );
                  }
                },
                builder: (context, state) {
                  return ListView(
                    controller: _scroll,
                    padding:
                        const EdgeInsets.only(top: 8, bottom: 8),
                    children: [
                      if (state.introVisible) ...[
                        const SizedBox(height: 8),
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Talk to your Creature!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1E28),
                                ),
                              ),
                              const SizedBox(height: 8),
                              SvgPicture.asset(
                                'assets/global/icons/creature.svg',
                                height: 140,
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ],
                      ...state.messages
                          .map((m) => ChatBotBubble(m)),
                    ],
                  );
                },
              ),
            ),
            _InputBar(
              controller: _c,
              onSend: (t) =>
                  context.read<ChatBotCubit>().send(t),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;

  const _InputBar({
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (v) {
                final t = v.trim();
                if (t.isEmpty) return;
                onSend(t);
                controller.clear();
              },
              decoration: InputDecoration(
                hintText: 'Type a message here',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.12),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(14),
                  ),
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.12),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                  borderSide: BorderSide(
                    color: Color(0xFF3380EF),
                    width: 1.6,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            backgroundColor: const Color(0xFF3380EF),
            elevation: 0,
            onPressed: () {
              final t = controller.text.trim();
              if (t.isEmpty) return;
              onSend(t);
              controller.clear();
            },
            child: const Icon(
              Icons.send_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
