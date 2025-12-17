import 'package:equatable/equatable.dart';

enum Sender { user, bot }

class Message extends Equatable {
  final String id;
  final String text;
  final DateTime ts;
  final Sender sender;

  const Message({
    required this.id,
    required this.text,
    required this.ts,
    required this.sender,
  });

  @override
  List<Object?> get props => [id, text, ts, sender];
}
