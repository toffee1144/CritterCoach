import 'dart:convert';
import 'package:critter_care/features/auth/auth_page.dart';
import 'package:http/http.dart' as http;
import '../models/plan_model.dart';
import 'planner_local_datasource.dart';
class PlannerRemoteDataSource implements PlannerLocalDataSource {
final String baseUrl;
final http.Client client;
final CurrentUserStore userStore;
PlannerRemoteDataSource({
required this.baseUrl,
required this.client,
required this.userStore,
});
String get _base {
if (baseUrl.endsWith('/')) return baseUrl.substring(0, baseUrl.length - 1);
return baseUrl;
}
int _requireUserId() {
final uid = userStore.id;
if (uid == null) {
throw Exception('Not logged in');
}
return uid;
}
String _ymd(DateTime d) {
final y = d.year.toString().padLeft(4, '0');
final m = d.month.toString().padLeft(2, '0');
final day = d.day.toString().padLeft(2, '0');
return '$y-$m-$day';
}
@override
Future<List<PlanModel>> getPlansByDate(DateTime date) async {
final uid = _requireUserId();
final day = DateTime(date.year, date.month, date.day);
final uri = Uri.parse('$_base/users/$uid/plans').replace(
  queryParameters: {'date': _ymd(day)},
);

final resp = await client.get(uri);

if (resp.statusCode != 200) {
  throw Exception('GET plans failed: ${resp.statusCode} ${resp.body}');
}

final jsonMap = jsonDecode(resp.body) as Map<String, dynamic>;
final list = (jsonMap['plans'] as List? ?? []).cast<dynamic>();

return list
    .map((e) => PlanModel.fromMap((e as Map).cast<String, dynamic>()))
    .toList();
}
@override
Future<PlanModel> addPlanAtTime(
DateTime day, {
required int hour,
required int minute,
required String title,
int difficulty = 1,
}) async {
final uid = _requireUserId();
final d = DateTime(day.year, day.month, day.day);
final uri = Uri.parse('$_base/users/$uid/plans');

final payload = {
  'date': _ymd(d),
  'hour': hour,
  'minute': minute,
  'title': title,
  'difficulty': difficulty,
};

final resp = await client.post(
  uri,
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode(payload),
);

if (resp.statusCode != 201) {
  throw Exception('POST plan failed: ${resp.statusCode} ${resp.body}');
}

final obj = (jsonDecode(resp.body) as Map).cast<String, dynamic>();
return PlanModel.fromMap(obj);
}
}