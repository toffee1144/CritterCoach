import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatroomPage extends StatelessWidget {
  final int squadId;
  final int currentUserId;
  final String currentUserName;

  const ChatroomPage({
    super.key,
    required this.squadId,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FB),
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: _ChatStream(
                squadId: squadId,
                currentUserId: currentUserId,
              ),
            ),
            _InputBar(
              squadId: squadId,
              currentUserId: currentUserId,
              currentUserName: currentUserName,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'Study Buddies',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  'Squads Space',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }
}

class _ChatStream extends StatefulWidget {
  final int squadId;
  final int currentUserId;

  const _ChatStream({
    required this.squadId,
    required this.currentUserId,
  });

  @override
  State<_ChatStream> createState() => _ChatStreamState();
}

class _ChatStreamState extends State<_ChatStream> {
  final ScrollController _controller = ScrollController();
  final int _limit = 20;

  List<QueryDocumentSnapshot> _messages = [];
  DocumentSnapshot? _lastDoc;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _loadInitial();
    _listenNewMessages();
    _controller.addListener(_onScroll);
  }

  void _listenNewMessages() {
    _sub = FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.squadId.toString())
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .listen((snap) {
      if (snap.docs.isEmpty) return;

      final newDoc = snap.docs.first;
      if (_messages.isNotEmpty && _messages.first.id == newDoc.id) return;

      setState(() {
        _messages.insert(0, newDoc);
      });
    });
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 100) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    final snap = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.squadId.toString())
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .limit(_limit)
        .get();

    setState(() {
      _messages = snap.docs;
      _lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    });
  }

  Future<void> _loadMore() async {
    if (_lastDoc == null) return;

    final snap = await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.squadId.toString())
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .startAfterDocument(_lastDoc!)
        .limit(_limit)
        .get();

    if (snap.docs.isEmpty) return;

    setState(() {
      _messages.addAll(snap.docs);
      _lastDoc = snap.docs.last;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final data = _messages[index].data() as Map<String, dynamic>;
        final senderId = data['senderId'];
        final isMe = senderId == widget.currentUserId;

        final isFirstInGroup =
            index == _messages.length - 1 ||
            (_messages[index + 1].data()
                    as Map<String, dynamic>)['senderId'] != senderId;

        final time = _formatTime(data['createdAt']);

        return isMe
            ? _OutgoingBubble(
                text: data['text'],
                time: time,
              )
            : _IncomingBubble(
                name: data['senderName'] ?? 'Unknown',
                text: data['text'],
                time: time,
                showHeader: isFirstInGroup,
              );
      },
    );
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }
}

class _IncomingBubble extends StatelessWidget {
  final String name;
  final String text;
  final String time;
  final bool showHeader;

  const _IncomingBubble({
    required this.name,
    required this.text,
    required this.time,
    required this.showHeader,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(text, softWrap: true),
            ),
          ),
          if (showHeader)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(time, style: const TextStyle(fontSize: 10)),
            ),
        ],
      ),
    );
  }
}

class _OutgoingBubble extends StatelessWidget {
  final String text;
  final String time;
  
  const _OutgoingBubble({
    required this.text,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width * 0.7;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFDA27),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      text,
                      softWrap: true,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(time, style: const TextStyle(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  final int squadId;
  final int currentUserId;
  final String currentUserName;

  const _InputBar({
    required this.squadId,
    required this.currentUserId,
    required this.currentUserName,
  });

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _controller.clear();

    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.squadId.toString())
        .collection('messages')
        .add({
      'squadId': widget.squadId,
      'senderId': widget.currentUserId,
      'senderName': widget.currentUserName,
      'text': text,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          const Icon(Icons.emoji_emotions_outlined,
              color: Color(0xFFFEAD00)),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Send a message...',
                  border: InputBorder.none,
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _send,
            child: const CircleAvatar(
              backgroundColor: Color(0xFFFEAD00),
              child: Icon(Icons.send_rounded, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

String _formatTime(dynamic ts) {
DateTime date;
if (ts is Timestamp) {
date = ts.toDate();
} else {
date = DateTime.now();
}
return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
}