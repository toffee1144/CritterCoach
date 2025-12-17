import 'dart:convert';
import 'package:critter_care/di/injector.dart';
import 'package:critter_care/features/squads/data/models/squads.dart';
import 'package:critter_care/features/squads/presentation/pages/squads_detail_page.dart';
import 'package:critter_care/features/squads/presentation/widgets/create_squad_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '../../../../core/ui/app_scaffold.dart';

const int currentUserId = 6;

class SquadsPage extends StatefulWidget {
  const SquadsPage({super.key});

  @override
  State<SquadsPage> createState() => _SquadsPageState();
}

class _SquadsPageState extends State<SquadsPage> {
  bool _loaded = false;
  bool _error = false;

  late final String _baseUrl;
  late final http.Client _client;

  final List<Squad> _mySquads = [];
  final List<Squad> _invitedSquads = [];

  @override
  void initState() {
    super.initState();
    _baseUrl = sl<String>(instanceName: 'baseUrl');
    _client = sl<http.Client>();
    _loadSquads();
  }

  String _iconAsset(String iconName) {
    final name = iconName.trim().isEmpty ? 'ic_book' : iconName.trim();
    return 'assets/features/squads/icons/$name.svg';
  }

  Future<void> _joinSquad(int squadId) async {
    final url = '$_baseUrl/squads/$squadId/join';
    try {
      final resp = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': currentUserId}),
      );

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('Join squad failed (${resp.statusCode})');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Joined squad')),
      );

      await _loadSquads();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Join failed: $e')),
      );
    }
  }

  Future<void> _declineSquad(int squadId) async {
    final url = '$_baseUrl/squads/$squadId/decline';
    try {
      final resp = await _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': currentUserId}),
      );

      if (resp.statusCode != 200) {
        throw Exception('Decline failed (${resp.statusCode})');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invite declined')),
      );

      await _loadSquads();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Decline failed: $e')),
      );
    }
  }

  Future<void> _createSquad() async {
    final name = 'New Squad ${DateTime.now().millisecondsSinceEpoch}';
    try {
      final resp = await _client.post(
        Uri.parse('$_baseUrl/squads'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'owner_id': currentUserId,
          'max_members': 10,
          'icon': 'ic_book',
        }),
      );

      if (resp.statusCode != 200 && resp.statusCode != 201) {
        throw Exception('Failed to create squad (${resp.statusCode})');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Squad created')),
      );

      await _loadSquads();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create squad failed: $e')),
      );
    }
  }

  Future<void> _loadSquads() async {
    if (!mounted) return;
    setState(() {
      _loaded = false;
      _error = false;
    });

    try {
      final myResp =
          await _client.get(Uri.parse('$_baseUrl/users/$currentUserId/squads'));
      final invitesResp =
          await _client.get(Uri.parse('$_baseUrl/users/$currentUserId/invites'));

      if (myResp.statusCode != 200 || invitesResp.statusCode != 200) {
        throw Exception(
            'Failed to load squads (my=${myResp.statusCode}, invites=${invitesResp.statusCode})');
      }

      final myData = jsonDecode(myResp.body) as Map<String, dynamic>;
      final invitesData = jsonDecode(invitesResp.body) as Map<String, dynamic>;

      final mySquadsJson =
          (myData['my_squads'] as List<dynamic>? ?? <dynamic>[]);

      final mySquads = mySquadsJson.map((e) {
        final map = Map<String, dynamic>.from(e as Map);
        map['members'] = map['members'] ?? map['members_count'] ?? 0;
        map['capacity'] = map['capacity'] ?? map['max_members'] ?? 0;
        map['icon'] = map['icon'] ?? 'ic_book';
        return Squad.fromJson(map, isMySquad: true);
      }).toList();

      final myIds = mySquads.map((e) => e.id).toSet();

      final invitesJson =
          (invitesData['invites'] as List<dynamic>? ?? <dynamic>[]);

      final invitedSquads = invitesJson.map((e) {
        final row = Map<String, dynamic>.from(e as Map);
        final squadMap = <String, dynamic>{
          'id': row['squad_id'],
          'name': row['squad_name'],
          'members': row['members'] ?? row['members_count'] ?? 0,
          'capacity': row['capacity'] ?? row['max_members'] ?? 0,
          'icon':
              row['icon'] ?? row['icon_name'] ?? row['squad_icon'] ?? 'ic_book',
        };
        return Squad.fromJson(squadMap, isMySquad: false);
      }).where((s) => !myIds.contains(s.id)).toList();

      if (!mounted) return;
      setState(() {
        _mySquads
          ..clear()
          ..addAll(mySquads);

        _invitedSquads
          ..clear()
          ..addAll(invitedSquads);

        _loaded = true;
        _error = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loaded = true;
        _error = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load squads: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return const AppScaffold(
        currentIndex: 3,
        background: Color(0xFFFDFDFD),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error) {
      return AppScaffold(
        currentIndex: 3,
        background: const Color(0xFFFDFDFD),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Failed to load squads',
                    style: TextStyle(color: Colors.red)),
                const SizedBox(height: 8),
                TextButton(onPressed: _loadSquads, child: const Text('Retry')),
              ],
            ),
          ),
        ),
      );
    }

    return AppScaffold(
      currentIndex: 3,
      background: const Color(0xFFFDFDFD),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadSquads,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildChip(
                  'My Squads',
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFF69E), Color(0xFFFFDA27)],
                  ),
                  textColor: Colors.black87,
                ),
                const SizedBox(height: 12),
                _buildMySquadsBlock(),
                const SizedBox(height: 24),
                _buildChip(
                  'Invited Squads',
                  gradient: const LinearGradient(
                    colors: [Color(0xFF32B3E7), Color(0xFF3380EF)],
                  ),
                  textColor: Colors.white,
                ),
                const SizedBox(height: 12),
                if (_invitedSquads.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Center(child: Text('No invites yet')),
                  )
                else
                  ..._invitedSquads.map(
                    (s) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildInviteCard(s),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Study Squads',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => CreateSquadPopup(
                baseUrl: _baseUrl,
                client: _client,
                currentUserId: currentUserId,
                onCreated: _loadSquads,
              ),
            );
          },
          icon: const Icon(Icons.add, size: 18, color: Colors.black87),
          label:
              const Text('Create\nSquads', textAlign: TextAlign.center),
        ),
      ],
    );
  }

  Widget _buildChip(String text,
      {required Gradient gradient, required Color textColor}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(text,
            style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w700)),
      ),
    );
  }

  Widget _buildMySquadsBlock() {
    if (_mySquads.isEmpty) {
      return _BaseCard(
        leading: _iconWithSvgBackground(
          bgAssetPath: 'assets/features/squads/icons/BG_Squad_Icon.svg',
          bgColor: const Color(0xFFFFF3CD),
          fgSvgAssetPath: _iconAsset('ic_book'),
        ),
        title: 'You are not in any squads yet',
        subtitle: 'Tap Create Squads to start one',
        trailing: ElevatedButton(
          onPressed: _createSquad,
          child: const Text('Create'),
        ),
      );
    }

    return Column(
      children: _mySquads.map((squad) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () async {
              final changed = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (_) => SquadDetailPage(squad: squad),
                ),
              );
              if (changed == true) await _loadSquads();
            },
            child: _BaseCard(
              leading: _iconWithSvgBackground(
                bgAssetPath: 'assets/features/squads/icons/BG_Squad_Icon.svg',
                bgColor: const Color(0xFFFFF3CD),
                fgSvgAssetPath: _iconAsset(squad.icon),
              ),
              title: squad.name,
              subtitle: 'Members: ${squad.members}/${squad.capacity}',
              trailing: const Icon(Icons.chevron_right_rounded,
                  size: 28, color: Colors.black54),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInviteCard(Squad squad) {
    return _BaseCard(
      leading: _iconWithSvgBackground(
        bgAssetPath: 'assets/features/squads/icons/BG_Squad_Icon.svg',
        bgColor: const Color(0xFFE3F2FD),
        fgSvgAssetPath: _iconAsset(squad.icon),
      ),
      title: squad.name,
      subtitle: 'Members: ${squad.members}/${squad.capacity}',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () => _declineSquad(squad.id),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFFF2929).withOpacity(0.9),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Reject'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => _joinSquad(squad.id),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3380EF),
              foregroundColor: Colors.white,
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );
  }

  Widget _iconWithSvgBackground({
    required String bgAssetPath,
    required Color bgColor,
    String? fgSvgAssetPath,
    double fgSize = 22,
  }) {
    return SizedBox(
      height: 52,
      width: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            bgAssetPath,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(bgColor, BlendMode.srcIn),
          ),
          SvgPicture.asset(
            fgSvgAssetPath ?? _iconAsset('ic_book'),
            width: fgSize,
            height: fgSize,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _BaseCard({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            spreadRadius: -2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            leading,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            trailing,
          ],
        ),
      ),
    );
  }
}
