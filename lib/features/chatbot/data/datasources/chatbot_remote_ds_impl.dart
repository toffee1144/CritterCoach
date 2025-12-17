// chatbot_remote_ds_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/message.dart';
import '../datasources/chatbot_remote_ds.dart';
class ChatBotRemoteDataSourceImpl implements ChatBotRemoteDataSource {
final String baseUrl;
final http.Client client;
ChatBotRemoteDataSourceImpl({
required this.baseUrl,
required this.client,
});
List<Map<String, String>> _toHistoryPayload(List<Message> history) {
final items = <Map<String, String>>[];
for (final m in history) {
final content = m.text.trim();
if (content.isEmpty) continue;
  final role = (m.sender == Sender.user) ? "user" : "assistant";
  items.add({"role": role, "content": content});
}
return items;
}
@override
Future<Message> getBotReply(
String userText, {
List<Message> history = const [],
}) async {
final uri = Uri.parse('$baseUrl/chatbot/reply');
final payload = {
  "text": userText.trim(),
  "history": _toHistoryPayload(history),
};

final res = await client.post(
  uri,
  headers: {"Content-Type": "application/json"},
  body: jsonEncode(payload),
);

if (res.statusCode < 200 || res.statusCode >= 300) {
  throw Exception('chatbot_reply_failed: ${res.statusCode} ${res.body}');
}

final data = jsonDecode(res.body) as Map<String, dynamic>;
final reply = (data["reply"] ?? "").toString().trim();

return Message(
  id: "b_${DateTime.now().microsecondsSinceEpoch}",
  text: reply.isEmpty ? "I’m here. Tell me more." : reply,
  ts: DateTime.now(),
  sender: Sender.bot,
);
}
}
