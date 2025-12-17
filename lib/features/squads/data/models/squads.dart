// lib/features/squads/data/models/squads.dart

class Squad {
  final int id;
  final String name;
  final int members;
  final int capacity;
  final String icon; // contoh: "ic_star" atau "ic_book"
  final bool isMySquad;
  final bool isLeader;

  const Squad({
    required this.id,
    required this.name,
    required this.members,
    required this.capacity,
    required this.icon,
    this.isMySquad = false,
    this.isLeader = false,
  });

  factory Squad.fromJson(
    Map<String, dynamic> json, {
    bool isMySquad = false,
  }) {
    final isLeaderRaw = json['is_leader'];
    final isLeader = _asBool(isLeaderRaw);

    final members = _asInt(json['members']) ??
        _asInt(json['members_count']) ??
        0;

    final capacity = _asInt(json['capacity']) ??
        _asInt(json['max_members']) ??
        0;

    final icon = (json['icon'] as String?)?.trim();
    final safeIcon = (icon == null || icon.isEmpty) ? 'ic_book' : icon;

    return Squad(
      id: _asInt(json['id']) ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
      members: members,
      capacity: capacity,
      icon: safeIcon,
      isMySquad: isMySquad,
      isLeader: isLeader,
    );
  }

  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static bool _asBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    if (v is num) return v.toInt() == 1;
    if (v is String) {
      final s = v.trim().toLowerCase();
      return s == '1' || s == 'true' || s == 'yes';
    }
    return false;
  }
}

class Member {
  final int userId;
  final String name;
  final String role;
  final int streak;
  final bool isLeader;

  const Member({
    required this.userId,
    required this.name,
    required this.role,
    required this.streak,
    this.isLeader = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    final rawRole = (json['role'] as String? ?? '').trim().toLowerCase();
    final isLeader = rawRole == 'leader';

    final displayRole = rawRole.isEmpty
        ? 'Member'
        : rawRole[0].toUpperCase() + rawRole.substring(1);

    return Member(
      userId: Squad._asInt(json['user_id']) ?? 0,
      name: (json['nickname'] ?? json['username'] ?? '') as String,
      role: displayRole,
      streak: (Squad._asInt(json['streak']) ?? 0),
      isLeader: isLeader,
    );
  }
}
