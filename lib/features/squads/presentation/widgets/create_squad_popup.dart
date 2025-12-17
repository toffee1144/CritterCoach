import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
class CreateSquadPopup extends StatefulWidget {
final String baseUrl;
final http.Client client;
final int currentUserId;
final VoidCallback onCreated;
const CreateSquadPopup({
super.key,
required this.baseUrl,
required this.client,
required this.currentUserId,
required this.onCreated,
});
@override
State<CreateSquadPopup> createState() => _CreateSquadPopupState();
}
class _CreateSquadPopupState extends State<CreateSquadPopup> {
final TextEditingController _nameCtrl = TextEditingController();
final TextEditingController _searchCtrl = TextEditingController();
bool _loading = false;
final List<int> _selectedUserIds = [];
List<Map<String, dynamic>> _searchResults = [];
final Map<String, String> _iconAssets = const {
'book': 'assets/features/squads/icons/ic_book.svg',
'star': 'assets/features/squads/icons/ic_star.svg',
};
late final List<String> _iconKeys;
String _selectedIconKey = 'book';
@override
void initState() {
super.initState();
_iconKeys = _iconAssets.keys.toList();
}
@override
void dispose() {
_nameCtrl.dispose();
_searchCtrl.dispose();
super.dispose();
}
Future<void> _searchUser(String q) async {
q = q.trim();
if (q.length < 2) {
if (!mounted) return;
setState(() => _searchResults = []);
return;
}
final uri = Uri.parse(
  '${widget.baseUrl}/users/search?q=${Uri.encodeQueryComponent(q)}',
);

final resp = await widget.client.get(uri);
if (resp.statusCode != 200) return;

final data = jsonDecode(resp.body) as Map<String, dynamic>;
final users = (data['users'] as List<dynamic>? ?? []);

if (!mounted) return;
setState(() {
  _searchResults = users
      .map((e) => Map<String, dynamic>.from(e as Map))
      .toList();
});
}
Future<void> _submit() async {
if (_nameCtrl.text.trim().isEmpty) return;
setState(() => _loading = true);

final resp = await widget.client.post(
  Uri.parse('${widget.baseUrl}/squads/create_with_members'),
  headers: {'Content-Type': 'application/json'},
  body: jsonEncode({
    'name': _nameCtrl.text.trim(),
    'icon_key': _selectedIconKey,
    'owner_id': widget.currentUserId,
    'member_ids': _selectedUserIds,
  }),
);

if (!mounted) return;
setState(() => _loading = false);

if (resp.statusCode == 200 || resp.statusCode == 201) {
  widget.onCreated();
  Navigator.pop(context);
}
}
@override
Widget build(BuildContext context) {
return Dialog(
insetPadding: const EdgeInsets.all(16),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
const Text(
'Create Squad',
style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
),
const SizedBox(height: 16),
        Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(
                _iconAssets[_selectedIconKey]!,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  hintText: 'Squad name',
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 56,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _iconKeys.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, i) {
              final key = _iconKeys[i];
              final selected = key == _selectedIconKey;

              return GestureDetector(
                onTap: () => setState(() => _selectedIconKey = key),
                child: Container(
                  width: 56,
                  decoration: BoxDecoration(
                    color: selected ? Colors.amber : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    _iconAssets[key]!,
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        TextField(
          controller: _searchCtrl,
          decoration: const InputDecoration(
            hintText: 'Search username',
          ),
          onChanged: _searchUser,
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 160,
          child: ListView(
            children: _searchResults.map((u) {
              final selected = _selectedUserIds.contains(u['id']);

              final sport = (u['sport'] ?? 'Basketball').toString();
              final athletic = (u['athletic_level_text'] ?? 'Rookie').toString();
              final level = (u['level'] ?? 0).toString();

              return ListTile(
                onTap: () {
                  setState(() {
                    selected
                        ? _selectedUserIds.remove(u['id'])
                        : _selectedUserIds.add(u['id']);
                  });
                },
                title: Text((u['username'] ?? '').toString()),
                subtitle: Text('Level $level • $sport • $athletic'),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create Squad'),
              ),
            ),
          ],
        ),
      ],
    ),
  ),
);
}
}
