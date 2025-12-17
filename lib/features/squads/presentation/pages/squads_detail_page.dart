import 'dart:convert';
import 'package:critter_care/di/injector.dart';
import 'package:critter_care/features/chatroom/presentation/pages/chatroom_page.dart';
import 'package:critter_care/features/squads/data/models/squads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
const int currentUserId = 6;
class SquadDetailPage extends StatefulWidget {
final Squad squad;
const SquadDetailPage({super.key, required this.squad});
@override
State<SquadDetailPage> createState() => _SquadDetailPageState();
}
class _SquadDetailPageState extends State<SquadDetailPage> {
late final String _baseUrl;
late final http.Client _client;
bool _loadingMembers = false;
bool _error = false;
final List<Member> _members = [];
@override
void initState() {
super.initState();
_baseUrl = sl<String>(instanceName: 'baseUrl');
_client = sl<http.Client>();
_loadMembers();
}
String _iconAsset(String iconName) {
final name = iconName.trim().isEmpty ? 'ic_book' : iconName.trim();
return 'assets/features/squads/icons/$name.svg';
}
Future<void> _loadMembers() async {
setState(() {
_loadingMembers = true;
_error = false;
});
final url = '$_baseUrl/squads/${widget.squad.id}';
debugPrint('GET squad detail: $url');

try {
  final resp = await _client.get(Uri.parse(url));
  debugPrint('detail.statusCode = ${resp.statusCode}');
  if (resp.statusCode != 200) {
    debugPrint('detail.body = ${resp.body}');
    throw Exception('Failed to load squad detail');
  }

  final data = jsonDecode(resp.body) as Map<String, dynamic>;
  final membersJson = data['members'] as List<dynamic>? ?? [];

  _members
    ..clear()
    ..addAll(
      membersJson.map((e) {
        final m = e as Map<String, dynamic>;

        final apiRole = (m['role'] as String?) ?? 'member';
        final status = (m['status'] as String?) ?? apiRole;

        final isLeader = apiRole == 'leader';
        final isPending = status == 'pending' || status == 'invited';

        final uiRole = isLeader
            ? 'Leader'
            : isPending
                ? 'Pending invite'
                : 'Group Member';

        return Member(
          userId: (m['user_id'] as num).toInt(),
          name: (m['nickname'] as String?)?.isNotEmpty == true
              ? m['nickname'] as String
              : (m['username'] as String? ?? 'Unknown'),
          role: uiRole,
          streak: isPending ? 0 : (m['streak'] as int?) ?? 0,
          isLeader: isLeader,
        );
      }),
    );

  setState(() {
    _loadingMembers = false;
    _error = false;
  });
} catch (e) {
  debugPrint('Error load members: $e');
  setState(() {
    _loadingMembers = false;
    _error = true;
  });
}
}
Future<void> _leaveSquad() async {
final confirm = await showDialog<bool>(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('Leave squad?'),
content: const Text('You will be removed from this squad.'),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx, false),
child: const Text('Cancel'),
),
TextButton(
onPressed: () => Navigator.pop(ctx, true),
child: const Text('Leave'),
),
],
),
);
if (confirm != true) return;

final url = '$_baseUrl/squads/${widget.squad.id}/leave';
debugPrint('POST leave: $url user=$currentUserId');

try {
  final resp = await _client.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'user_id': currentUserId}),
  );

  debugPrint('leave.statusCode = ${resp.statusCode}');
  debugPrint('leave.body = ${resp.body}');

  if (resp.statusCode != 200) {
    throw Exception('Leave squad failed (${resp.statusCode})');
  }

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('You left the squad')),
  );
  Navigator.pop(context, true);
} catch (e) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Leave failed: $e')),
  );
}
}
Future<void> _deleteSquad() async {
final confirm = await showDialog<bool>(
context: context,
builder: (ctx) => AlertDialog(
title: const Text('Delete squad?'),
content: const Text('This action will remove the squad and all its members.'),
actions: [
TextButton(
onPressed: () => Navigator.pop(ctx, false),
child: const Text('Cancel'),
),
TextButton(
onPressed: () => Navigator.pop(ctx, true),
child: const Text('Delete'),
),
],
),
);
if (confirm != true) return;

final url = '$_baseUrl/squads/${widget.squad.id}?user_id=$currentUserId';
debugPrint('DELETE squad: $url');

try {
  final resp = await _client.delete(Uri.parse(url));
  debugPrint('delete.statusCode = ${resp.statusCode}');
  debugPrint('delete.body = ${resp.body}');

  if (resp.statusCode != 200) {
    throw Exception('Delete squad failed (${resp.statusCode})');
  }

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Squad deleted')),
  );
  Navigator.pop(context, true);
} catch (e) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Delete failed: $e')),
  );
}
}
Future<void> _inviteByUsername() async {
final username = await showDialog<String>(
context: context,
barrierDismissible: true,
barrierColor: Colors.black.withOpacity(0.18),
builder: (ctx) {
final controller = TextEditingController();
const cBlue = Color(0xFF3380EF);
const cYellow = Color.fromARGB(255, 255, 239, 9);
const cRed = Color(0xFFFF2929);
const cPage = Color(0xFFFFF9C4);
    return StatefulBuilder(
      builder: (ctx, setLocal) {
        bool loading = false;

        Future<void> submit() async {
          final value = controller.text.trim();
          if (value.isEmpty) return;
          setLocal(() => loading = true);
          await Future.delayed(const Duration(milliseconds: 120));
          if (!ctx.mounted) return;
          Navigator.pop(ctx, value);
        }

        final canSubmit = controller.text.trim().isNotEmpty && !loading;

        return Dialog(
          backgroundColor: cPage,
          insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(color: Colors.black87, width: 1.2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: cBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                  border: Border(
                    bottom: BorderSide(color: Colors.black87, width: 1.2),
                  ),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 22),
                    SizedBox(width: 10),
                    Text(
                      'Invite',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 14,
                  bottom: 14 + MediaQuery.of(ctx).viewInsets.bottom,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: controller,
                      autofocus: true,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => submit(),
                      onChanged: (_) => setLocal(() {}),
                      decoration: InputDecoration(
                        hintText: 'Type username',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: Colors.black26, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: cBlue, width: 2.2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: loading ? null : () => Navigator.pop(ctx, null),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cRed,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: Colors.black87, width: 1.2),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: canSubmit ? submit : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cYellow,
                                foregroundColor: Colors.black87,
                                disabledBackgroundColor: cYellow.withOpacity(0.45),
                                disabledForegroundColor: Colors.black54,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(color: Colors.black87, width: 1.2),
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      height: 18,
                                      width: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                                      ),
                                    )
                                  : const Text(
                                      'Invite',
                                      style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  },
);

if (username == null || username.trim().isEmpty) return;

final url = '$_baseUrl/squads/${widget.squad.id}/invite';
try {
  final resp = await _client.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'username': username.trim(),
      'inviter_id': currentUserId,
    }),
  );

  if (resp.statusCode != 200 && resp.statusCode != 201) {
    throw Exception('Invite failed (${resp.statusCode})');
  }

  await _loadMembers();

  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Invited ${username.trim()}')),
  );
} catch (e) {
  if (!mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Invite failed: $e')),
  );
}
}
@override
Widget build(BuildContext context) {
final squad = widget.squad;
final isLeader = squad.isLeader;
final activeCount =
    _members.where((m) => !m.role.toLowerCase().contains('pending')).length;

return Scaffold(
  backgroundColor: const Color(0xFFFFF9C4),
  body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 16, top: 0),
            child: SizedBox(
              height: 184,
              width: double.infinity,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _topSquareButton(
                          color: const Color(0xFFFFDA27),
                          icon: Icons.person_add_alt_1_rounded,
                          label: 'Invite',
                          onTap: _inviteByUsername,
                          width: 56,
                        ),
                        const SizedBox(height: 10),
                        _topSquareButton(
                          color: const Color(0xFFF44336),
                          icon: isLeader
                              ? Icons.delete_forever_rounded
                              : Icons.exit_to_app_rounded,
                          label: isLeader ? 'Delete\nSquad' : 'Leave\nSquads',
                          onTap: isLeader ? _deleteSquad : _leaveSquad,
                          width: 56,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 72,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SizedBox(
                        height: 104,
                        width: 104,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/features/squads/icons/BG_Squad_Icon.svg',
                              width: 96,
                              height: 96,
                              fit: BoxFit.contain,
                            ),
                            SvgPicture.asset(
                              _iconAsset(squad.icon),
                              width: 52,
                              height: 52,
                              fit: BoxFit.contain,
                              colorFilter: const ColorFilter.mode(
                                Colors.black87,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            squad.name,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.call_rounded),
              label: const Text('Join Voice Calls'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () async {
                final myName = _members
                    .firstWhere((m) => m.userId == currentUserId)
                    .name;

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatroomPage(
                      squadId: squad.id,
                      currentUserId: currentUserId,
                      currentUserName: myName,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.emoji_emotions_outlined),
              label: const Text('Group Chat'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFDA27),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Members $activeCount',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              const Text(
                'Daily Streaks',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _loadingMembers
                ? const Center(child: CircularProgressIndicator())
                : _error
                    ? const Center(child: Text('Failed to load members'))
                    : ListView.separated(
                        itemCount: _members.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final m = _members[index];
                          final isPending =
                              m.role.toLowerCase().contains('pending');

                          return Row(
                            children: [
                              Container(
                                height: 42,
                                width: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isPending
                                        ? Colors.grey
                                        : const Color(0xFF2979FF),
                                    width: 2,
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      m.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: isPending
                                            ? Colors.grey.shade600
                                            : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      m.isLeader
                                          ? 'Leader ⭐'
                                          : isPending
                                              ? 'Group Member'
                                              : m.role,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isPending
                                            ? Colors.grey
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.local_fire_department_rounded,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    (isPending ? 0 : m.streak).toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    ),
  ),
);
}
Widget _topSquareButton({
required Color color,
required IconData icon,
required String label,
required VoidCallback onTap,
double width = 56,
}) {
return GestureDetector(
onTap: onTap,
child: Container(
width: width,
height: 56,
decoration: BoxDecoration(
color: color,
borderRadius: BorderRadius.circular(10),
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Icon(icon, size: 20, color: Colors.black87),
const SizedBox(height: 4),
Text(
label,
textAlign: TextAlign.center,
style: const TextStyle(
fontSize: 11,
fontWeight: FontWeight.w700,
height: 1.05,
color: Colors.black87,
),
),
],
),
),
);
}
}