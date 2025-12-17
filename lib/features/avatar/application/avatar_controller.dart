import 'dart:convert';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/models/cosmetic_def.dart';
import '../domain/models/user_profile.dart';
import '../domain/models/avatar_state.dart';
import '../../auth/auth_page.dart'; // CurrentUserStore

final sl = GetIt.instance;
class AvatarController {
static final AvatarController _instance = AvatarController._internal();
AvatarController._internal();
factory AvatarController() => _instance;
static const kStatePrefix = 'avatar_state';
late final SharedPreferences _prefs;
late final CurrentUserStore _userStore;
late final http.Client _client;
late final String _baseUrl;
bool _inited = false;
final Map<String, CosmeticDef> _catalogById = {};
UserProfile? _profile;
Future<void> _ensureDeps() async {
if (_inited) return;
_prefs = sl<SharedPreferences>();
_userStore = sl<CurrentUserStore>();
_client = sl<http.Client>();
_baseUrl = sl<String>(instanceName: 'baseUrl');
_inited = true;
}
Uri _u(String path) {
final b = _baseUrl.endsWith('/') ? _baseUrl.substring(0, _baseUrl.length - 1) : _baseUrl;
return Uri.parse('$b$path');
}
int? get _uid => _userStore.id;
String _kState(int uid) => '$kStatePrefix$uid';
Future<void> loadInitialData() async {
await _ensureDeps();
final uid = _uid;
if (uid == null) {
  _profile = null;
  _catalogById.clear();
  return;
}

final cached = _readCache(uid);
if (cached != null) {
  _applyStateJson(cached);
}

final fresh = await _fetchState(uid);
_applyStateJson(fresh);
await _writeCache(uid, fresh);
}
Map<String, dynamic>? _readCache(int uid) {
final raw = _prefs.getString(_kState(uid));
if (raw == null || raw.trim().isEmpty) return null;
try {
return jsonDecode(raw) as Map<String, dynamic>;
} catch (_) {
return null;
}
}
Future<void> _writeCache(int uid, Map<String, dynamic> j) async {
await _prefs.setString(_kState(uid), jsonEncode(j));
}
Future<Map<String, dynamic>> _fetchState(int uid) async {
final r = await _client.get(_u('/users/$uid/avatar'), headers: {'Accept': 'application/json'});
if (r.statusCode != 200) {
throw Exception(r.body);
}
return jsonDecode(r.body) as Map<String, dynamic>;
}
Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async {
final r = await _client.post(
_u(path),
headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
body: jsonEncode(body),
);
if (r.statusCode < 200 || r.statusCode >= 300) {
throw Exception(r.body);
}
if (r.body.trim().isEmpty) return <String, dynamic>{};
return jsonDecode(r.body) as Map<String, dynamic>;
}
void _applyStateJson(Map<String, dynamic> j) {
final coins = (j['coins'] as num?)?.toInt() ?? 0;
final owned = ((j['owned'] as List?) ?? const [])
    .map((e) => e.toString())
    .toList();

final equipped = ((j['equipped'] as Map?) ?? const {})
    .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

equipped.removeWhere((k, v) => v.trim().isEmpty);

final catalogList = ((j['catalog'] as List?) ?? const [])
    .map((e) => CosmeticDef.fromJson(e as Map<String, dynamic>))
    .toList();

_catalogById.clear();
for (final c in catalogList) {
  _catalogById[c.id] = c;
}

_profile = UserProfile(
  userId: (j['user_id'] as num?)?.toInt() ?? 0,
  coins: coins,
  ownedItems: owned,
  equipped: equipped,
);
}
int get coins => _profile?.coins ?? 0;
AvatarState get avatarState {
if (_profile == null) {
return const AvatarState(body: 'assets/avatar/base/Creature.svg');
}
String? resolve(String slot) {
  final itemId = _profile!.equipped[slot];
  if (itemId == null) return null;
  final def = _catalogById[itemId];
  if (def == null) return null;
  return def.assetPathLocal;
}

return AvatarState(
  body: 'assets/avatar/base/Creature.svg',
  hair: resolve('hair'),
  headAccessory: resolve('headAccessory'),
  faceAccessory: resolve('faceAccessory'),
  outfit: resolve('outfit'),
  backAccessory: resolve('backAccessory'),
  accessory: resolve('accessory'),
);
}
List<CosmeticDef> getItemsBySlot(String slotName) {
if (slotName == 'accessory') {
return _catalogById.values
.where((c) => c.slot == 'accessory' || c.slot == 'backAccessory' || c.slot == 'faceAccessory')
.toList();
}
return _catalogById.values.where((c) => c.slot == slotName).toList();
}
bool userOwns(String cosmeticId) {
if (_profile == null) return false;
return _profile!.ownedItems.contains(cosmeticId);
}
bool isEquipped(String cosmeticId) {
if (_profile == null) return false;
final def = _catalogById[cosmeticId];
if (def == null) return false;
final equippedId = _profile!.equipped[def.slot];
return equippedId == cosmeticId;
}
Future<void> unequipSlot(String slotName) async {
await _ensureDeps();
final uid = _uid;
if (uid == null) return;
final res = await _post('/users/$uid/avatar/equip', {'slot': slotName, 'cosmetic_id': null});

final cached = _readCache(uid) ?? <String, dynamic>{'user_id': uid};
cached['equipped'] = (res['equipped'] as Map?) ?? const {};
if (cached['coins'] == null && _profile != null) cached['coins'] = _profile!.coins;
if (cached['owned'] == null && _profile != null) cached['owned'] = _profile!.ownedItems;
if (cached['catalog'] == null) cached['catalog'] = _catalogById.values.map((e) => e.toJson()).toList();

_applyStateJson(cached);
await _writeCache(uid, cached);
}
Future<void> equip(String cosmeticId) async {
await _ensureDeps();
final uid = _uid;
if (uid == null) return;
final def = _catalogById[cosmeticId];
if (def == null) return;

if (!userOwns(cosmeticId)) return;

final res = await _post('/users/$uid/avatar/equip', {'slot': def.slot, 'cosmetic_id': cosmeticId});

final cached = _readCache(uid) ?? <String, dynamic>{'user_id': uid};
cached['equipped'] = (res['equipped'] as Map?) ?? const {};
if (cached['coins'] == null && _profile != null) cached['coins'] = _profile!.coins;
if (cached['owned'] == null && _profile != null) cached['owned'] = _profile!.ownedItems;
if (cached['catalog'] == null) cached['catalog'] = _catalogById.values.map((e) => e.toJson()).toList();

_applyStateJson(cached);
await _writeCache(uid, cached);
}
Future<bool> buy(String cosmeticId) async {
await _ensureDeps();
final uid = _uid;
if (uid == null) return false;
try {
  final res = await _post('/users/$uid/avatar/buy', {'cosmetic_id': cosmeticId});

  final state = await _fetchState(uid);
  _applyStateJson(state);
  await _writeCache(uid, state);

  return true;
} catch (_) {
  return false;
}
}
List<CosmeticDef> get shopItems {
if (_profile == null) return const [];
final owned = _profile!.ownedItems.toSet();
return _catalogById.values.where((c) => c.available && !owned.contains(c.id)).toList();
}
Map<String, String> get equippedMap {
if (_profile == null) return const {};
return Map<String, String>.from(_profile!.equipped);
}
List<String> get ownedList {
if (_profile == null) return const [];
return List<String>.from(_profile!.ownedItems);
}
}
