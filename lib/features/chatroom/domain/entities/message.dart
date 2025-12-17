class ChatMessage {
  final String id;
  final int squadId;
  final int senderId;
  final String senderName;
  final String senderAvatar;
  final String text;
  final DateTime createdAt;
  final List<int> seenBy;
  
  ChatMessage({
    required this.id,
    required this.squadId,
    required this.senderId,
    required this.senderName,
    required this.senderAvatar,
    required this.text,
    required this.createdAt,
    required this.seenBy,
  });

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
    id: id,
    squadId: map['squadId'],
    senderId: map['senderId'],
    senderName: map['senderName'],
    senderAvatar: map['senderAvatar'],
    text: map['text'],
    createdAt: map['createdAt'].toDate(),
    seenBy: List<int>.from(map['seenBy'] ?? []),
    );
  }
}
