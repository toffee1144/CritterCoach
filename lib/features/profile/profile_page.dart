import 'dart:convert';

import 'package:critter_care/core/ui/app_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:critter_care/di/injector.dart';

// Helper function to convert dynamic to int safely

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

class UserProfile {
  final int id;
  final String username;
  final String nickname;
  final int xp;
  final int coins;
  final int completedQuests;
  final int totalTimeHours;

  UserProfile({
    required this.id,
    required this.username,
    required this.nickname,
    required this.xp,
    required this.coins,
    required this.completedQuests,
    required this.totalTimeHours,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>;
    final wallet = json['wallet'] as Map<String, dynamic>;
    final stats = json['stats'] as Map<String, dynamic>;

    return UserProfile(
      id: _toInt(user['id']),
      username: user['username'] as String? ?? '',
      nickname: user['nickname'] as String? ?? '',
      xp: _toInt(wallet['xp']),
      coins: _toInt(wallet['coins']),
      completedQuests: _toInt(stats['completed_quests']),
      totalTimeHours: _toInt(stats['total_time_spent_hours']),
    );
  }

  int get level {
    if (xp <= 0) return 1;
    return (xp / 1000).floor() + 1;
  }

  int get rankPosition {
    return 1;
  }
}

class CompletedQuest {
  final int id;
  final String title;
  final String description;
  final DateTime? completedAt;
  final int xp;
  final int coins;

  CompletedQuest({
    required this.id,
    required this.title,
    required this.description,
    required this.completedAt,
    required this.xp,
    required this.coins,
  });

  factory CompletedQuest.fromJson(Map<String, dynamic> json) {
    DateTime? completed;
    if (json['completed_at'] != null) {
      completed = DateTime.tryParse(json['completed_at'] as String);
    }

    return CompletedQuest(
      id: _toInt(json['quest_instance_id']),
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      completedAt: completed,
      xp: _toInt(json['xp']),
      coins: _toInt(json['coins']),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // sementara hardcode, nanti bisa diambil dari auth/current user
  static const int _userId = 1;

  late Future<UserProfile> _profileFuture;
  late Future<List<CompletedQuest>> _completedQuestsFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _fetchProfile(_userId);
    _completedQuestsFuture = _fetchCompletedQuests(_userId);
  }

  Future<UserProfile> _fetchProfile(int userId) async {
    final baseUrl = sl<String>(instanceName: 'baseUrl');
    final url = Uri.parse('$baseUrl/users/$userId/profile');
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to load profile: ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    return UserProfile.fromJson(data);
  }

  Future<List<CompletedQuest>> _fetchCompletedQuests(int userId) async {
    final baseUrl = sl<String>(instanceName: 'baseUrl');
    final url = Uri.parse('$baseUrl/users/$userId/quests/completed');
    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception('Failed to load completed quests: ${res.body}');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final List quests = data['quests'] as List? ?? [];

    return quests
        .map((q) => CompletedQuest.fromJson(q as Map<String, dynamic>))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const AppBottomNav(currentIndex: 4),
      body: SafeArea(
        child: FutureBuilder<UserProfile>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              );
            }

            final profile = snapshot.data!;
            return _buildContent(profile);
          },
        ),
      ),
    );
  }

  Widget _buildContent(UserProfile profile) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(profile),
          const SizedBox(height: 16),
          _buildStatsSection(profile),
          const SizedBox(height: 16),
          _buildCompletedQuestSection(),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.only(top: 24, bottom: 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF3BB7FF),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.settings,
                    size: 20,
                    color: Color(0xFFFFC73B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 120,
            height: 120,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            alignment: Alignment.center,
            child: Text(
              profile.nickname.isNotEmpty
                  ? profile.nickname[0].toUpperCase()
                  : 'U',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFFC73B),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            profile.nickname.isNotEmpty
                ? profile.nickname
                : profile.username,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Level ${profile.level} • Top ${profile.rankPosition} Rank',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent.shade400,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.local_fire_department,
                  color: Colors.yellow,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  '0-Day Streak',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(UserProfile profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFD54F),
                        Color(0xFFFF7043),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(
                        Icons.emoji_events_outlined,
                        color: Colors.white,
                        size: 30,
                      ),
                      Spacer(),
                      Text(
                        'Achievements',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF42A5F5),
                        Color(0xFF1976D2),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.yellow,
                        size: 30,
                      ),
                      const Spacer(),
                      const Text(
                        'Coins',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile.coins.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Statistics',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.stars, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                profile.xp.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Text('XP Points Earned'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.task_alt, color: Colors.green),
              const SizedBox(width: 8),
              Text(
                profile.completedQuests.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Text('Quest Completed'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Total Time Spent',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Text(
                '${profile.totalTimeHours} hours',
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final progress = (profile.xp % 1000) / 1000.0;
                  final width = maxWidth * progress;
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: width,
                      height: 14,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF42A5F5),
                            Color(0xFFFFC400),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletedQuestSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Completed Quests',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 8),
          FutureBuilder<List<CompletedQuest>>(
            future: _completedQuestsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              final quests = snapshot.data ?? [];
              if (quests.isEmpty) {
                return const Text('Belum ada quest yang selesai.');
              }

              return Column(
                children: quests.map((q) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 1),
                          blurRadius: 3,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                q.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                q.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '+${q.xp} XP • +${q.coins} Coins',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.blueGrey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
