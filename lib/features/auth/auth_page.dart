import 'dart:async';
import 'dart:convert';
import 'package:critter_care/features/avatar/application/avatar_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

class AuthUser {
  final int id;
  final String username;
  final String nickname;
  final String sport;
  final int athleticLevel;

  const AuthUser({
    required this.id,
    required this.username,
    required this.nickname,
    required this.sport,
    required this.athleticLevel,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'nickname': nickname,
        'sport': sport,
        'athletic_level': athleticLevel,
      };

  static AuthUser fromJson(Map<String, dynamic> j) => AuthUser(
        id: (j['id'] as num).toInt(),
        username: (j['username'] ?? '').toString(),
        nickname: (j['nickname'] ?? '').toString(),
        sport: (j['sport'] ?? '').toString(),
        athleticLevel: (j['athletic_level'] as num?)?.toInt() ?? 1,
      );
}

class CurrentUserStore extends ChangeNotifier {
  static const _kUser = 'auth_user';

  final SharedPreferences prefs;

  bool _loading = false;
  AuthUser? _user;

  CurrentUserStore(this.prefs);

  bool get loading => _loading;
  AuthUser? get user => _user;
  int? get id => _user?.id;

  Future<void> loadFromPrefs() async {
    _loading = true;
    notifyListeners();

    final raw = prefs.getString(_kUser);
    if (raw == null || raw.trim().isEmpty) {
      _user = null;
      _loading = false;
      notifyListeners();
      return;
    }

    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      _user = AuthUser.fromJson(j);
    } catch (_) {
      _user = null;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> setUser(AuthUser u) async {
    _user = u;
    await prefs.setString(_kUser, jsonEncode(u.toJson()));
    notifyListeners();
  }

  Future<void> clear() async {
    _user = null;
    await prefs.remove(_kUser);
    notifyListeners();
  }
}

class AuthApi {
  final String baseUrl;
  final http.Client client;

  AuthApi({
    required this.baseUrl,
    required this.client,
  });

  Uri _u(String path, [Map<String, String>? q]) {
    final b = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return Uri.parse('$b$path').replace(queryParameters: q);
  }

  String? _errMsg(String body) {
    try {
      final j = jsonDecode(body) as Map<String, dynamic>;
      return j['error']?.toString() ??
          j['detail']?.toString() ??
          j['message']?.toString();
    } catch (e) {
      return null;
    }
  }

  Future<bool> checkUsername(String username) async {
    final r = await client.get(
      _u('/auth/check_username', {'username': username}),
      headers: {'Accept': 'application/json'},
    );

    if (r.statusCode != 200) return false;

    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return j['available'] == true;
  }

  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final r = await client.post(
      _u('/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (r.statusCode != 200) {
      throw Exception(_errMsg(r.body) ?? 'Login failed');
    }

    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return AuthUser.fromJson(j['user'] as Map<String, dynamic>);
  }

  Future<AuthUser> signup({
    required String nickname,
    required String username,
    required String password,
    required String sport,
    required int athleticLevel,
  }) async {
    final r = await client.post(
      _u('/auth/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nickname': nickname,
        'username': username,
        'password': password,
        'sport': sport,
        'athletic_level': athleticLevel,
      }),
    );

    if (r.statusCode != 201) {
      throw Exception(_errMsg(r.body) ?? 'Sign up failed');
    }

    final j = jsonDecode(r.body) as Map<String, dynamic>;
    return AuthUser.fromJson(j['user'] as Map<String, dynamic>);
  }
}

class AuthGate extends StatefulWidget {
  final Widget Function(BuildContext context, AuthUser user) authedBuilder;
  final WidgetBuilder unauthedBuilder;

  const AuthGate({
    super.key,
    required this.authedBuilder,
    required this.unauthedBuilder,
  });

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _booted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_booted) return;
    _booted = true;

    final store = sl<CurrentUserStore>();
    store.loadFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    final store = sl<CurrentUserStore>();

    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        if (store.loading) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final u = store.user;
        if (u != null) return widget.authedBuilder(context, u);

        return widget.unauthedBuilder(context);
      },
    );
  }
}

class AuthPage extends StatefulWidget {
  final VoidCallback? onAuthed;

  const AuthPage({
    super.key,
    this.onAuthed,
  });

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  static const _yellow = Color(0xFFFFDA27);
  static const _blue = Color(0xFF3380EF);
  static const _card = Color(0xFFFFF9D7);
  static const _waveYellowAsset = 'assets/auth/Vector.svg';
  static const _waveWhiteAsset = 'assets/auth/Vector-2.svg';

  final _loginUserCtrl = TextEditingController();
  final _loginPassCtrl = TextEditingController();

  final _signNickCtrl = TextEditingController();
  final _signUserCtrl = TextEditingController();
  final _signPassCtrl = TextEditingController();

  bool _isSignup = false;
  bool _busy = false;

  Timer? _debounce;

  bool? _usernameAvailable;
  String _usernameHint = '';

  String _signupPassHint = '';
  String _loginPassHint = '';

  bool _policyAgree = true;

  String _sport = 'Football';
  int _level = 1;

  late final AuthApi _api;
  late final CurrentUserStore _userStore;

  @override
  void initState() {
    super.initState();

    _api = sl<AuthApi>();
    _userStore = sl<CurrentUserStore>();

    _signUserCtrl.addListener(_onUsernameChanged);

    _signPassCtrl.addListener(() {
      setState(() => _signupPassHint = _strengthText(_signPassCtrl.text));
    });

    _loginPassCtrl.addListener(() {
      setState(() => _loginPassHint = _strengthText(_loginPassCtrl.text));
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();

    _loginUserCtrl.dispose();
    _loginPassCtrl.dispose();

    _signNickCtrl.dispose();
    _signUserCtrl.dispose();
    _signPassCtrl.dispose();

    super.dispose();
  }

  void _onUsernameChanged() {
    final u = _signUserCtrl.text.trim();
    _debounce?.cancel();

    if (u.isEmpty) {
      setState(() {
        _usernameAvailable = null;
        _usernameHint = '';
      });
      return;
    }

    if (u.length < 3 || u.contains(' ')) {
      setState(() {
        _usernameAvailable = false;
        _usernameHint = 'Invalid';
      });
      return;
    }

    setState(() {
      _usernameAvailable = null;
      _usernameHint = 'Checking';
    });

    _debounce = Timer(const Duration(milliseconds: 450), () async {
      try {
        final ok = await _api.checkUsername(u);
        if (!mounted) return;
        setState(() {
          _usernameAvailable = ok;
          _usernameHint = ok ? 'Available' : 'Taken';
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _usernameAvailable = false;
          _usernameHint = 'Error';
        });
      }
    });
  }

  String _strengthText(String p) {
    if (p.trim().isEmpty) return '';
    final hasLetter = RegExp(r'[A-Za-z]').hasMatch(p);
    final hasNum = RegExp(r'[0-9]').hasMatch(p);
    if (p.length >= 10 && hasLetter && hasNum) return 'Strong';
    if (p.length >= 6 && (hasLetter || hasNum)) return 'Okay';
    return 'Weak';
  }

  Future<void> _doLogin() async {
    final username = _loginUserCtrl.text.trim();
    final password = _loginPassCtrl.text;

    if (username.isEmpty || password.isEmpty) {
      _toast('Fill username and password');
      return;
    }

    if (!_policyAgree) {
      _toast('Turn on the toggle');
      return;
    }

    setState(() => _busy = true);
    try {
    final user = await _api.login(username: username, password: password);
    await _userStore.setUser(user);
    await AvatarController().loadInitialData();

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/home');
    _toast('Logged in');
    } catch (e) {
    _toast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
    if (mounted) setState(() => _busy = false);
    }
  }
  Future<void> _doSignup() async {
    final nickname = _signNickCtrl.text.trim();
    final username = _signUserCtrl.text.trim();
    final password = _signPassCtrl.text;

    if (nickname.isEmpty || username.isEmpty || password.isEmpty) {
      _toast('Fill all fields');
      return;
    }

    if (_usernameAvailable != true) {
      _toast('Username must be unique');
      return;
    }

    if (!_policyAgree) {
      _toast('Turn on the toggle');
      return;
    }

    setState(() => _busy = true);
    try {
      final user = await _api.signup(
        nickname: nickname,
        username: username,
        password: password,
        sport: _sport,
        athleticLevel: _level,
      );
      await _userStore.setUser(user);
      widget.onAuthed?.call();
      if (mounted) _toast('Account created');
    } catch (e) {
      _toast(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _toast(String s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(s), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isSignup ? _yellow : Colors.white;
    final waveAsset = _isSignup ? _waveWhiteAsset : _waveYellowAsset;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: -2,
              child: SvgPicture.asset(
                waveAsset,
                fit: BoxFit.fitWidth,
                height: 110,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isSignup ? 'Sign Up' : 'Login',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            _MascotHeader(isSignup: _isSignup),
                            const SizedBox(height: 10),
                            _AuthCard(
                              color: _card,
                              child: _isSignup
                                  ? _buildSignupForm()
                                  : _buildLoginForm(),
                            ),
                            const SizedBox(height: 18),
                            _SwitchFooter(
                              isSignup: _isSignup,
                              onToggleMode: () =>
                                  setState(() => _isSignup = !_isSignup),
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_busy)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.12),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Username'),
        const SizedBox(height: 8),
        _TextFieldWithHint(
          controller: _loginUserCtrl,
          hint: 'Username',
          rightText: '',
          rightIcon: null,
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        const _Label('Password'),
        const SizedBox(height: 8),
        _TextFieldWithHint(
          controller: _loginPassCtrl,
          hint: 'Password',
          obscure: true,
          rightText: _loginPassHint.isEmpty ? '' : _loginPassHint,
          rightIcon: (_loginPassHint == 'Strong' || _loginPassHint == 'Okay')
              ? Icons.check
              : null,
          onChanged: (_) {},
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                "We don’t collect any personal data.",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            Switch(
              value: _policyAgree,
              activeColor: _blue,
              onChanged: (v) => setState(() => _policyAgree = v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _busy ? null : _doLogin,
            
            child: const Text(
              'Login',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm() {
    final rightText = _usernameHint.isEmpty ? '' : _usernameHint;
    final rightIcon = _usernameAvailable == true ? Icons.check : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _Label('Nickname'),
        const SizedBox(height: 8),
        _TextFieldWithHint(
          controller: _signNickCtrl,
          hint: 'Nickname',
          rightText: '',
          rightIcon: null,
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        const _Label('Username'),
        const SizedBox(height: 8),
        _TextFieldWithHint(
          controller: _signUserCtrl,
          hint: 'Username',
          rightText: rightText,
          rightIcon: rightIcon,
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        const _Label('Password'),
        const SizedBox(height: 8),
        _TextFieldWithHint(
          controller: _signPassCtrl,
          hint: 'Password',
          obscure: true,
          rightText: _signupPassHint.isEmpty ? '' : _signupPassHint,
          rightIcon:
              (_signupPassHint == 'Strong' || _signupPassHint == 'Okay')
                  ? Icons.check
                  : null,
          onChanged: (_) {},
        ),
        const SizedBox(height: 14),
        const _Label('Sport'),
        const SizedBox(height: 8),
        _DropdownBox(
          value: _sport,
          items: const ['Football', 'Tennis', 'Gym', 'Running', 'Basketball'],
          onChanged: (v) => setState(() => _sport = v),
        ),
        const SizedBox(height: 14),
        const _Label('Athletic Level'),
        const SizedBox(height: 8),
        _LevelSelector(
          value: _level,
          onChanged: (v) => setState(() => _level = v),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text(
                "We don’t collect any personal data.",
                style: TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
            Switch(
              value: _policyAgree,
              activeColor: _blue,
              onChanged: (v) => setState(() => _policyAgree = v),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            onPressed: _busy ? null : _doSignup,
            child: const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MascotHeader extends StatelessWidget {
  final bool isSignup;

  const _MascotHeader({required this.isSignup});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 118,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                isSignup
                    ? 'Welcome, create your account!'
                    : 'Hello, welcome back!',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const Positioned(
            bottom: 0,
            child: _Chick(),
          ),
        ],
      ),
    );
  }
}

class _Chick extends StatelessWidget {
  const _Chick();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 84,
      child: CustomPaint(
        painter: _ChickPainter(const Color(0xFFFFDA27)),
      ),
    );
  }
}

class _ChickPainter extends CustomPainter {
  final Color color;

  _ChickPainter(this.color);

  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = color;

    final face = Rect.fromCenter(
      center: Offset(s.width / 2, s.height / 2 + 6),
      width: 84,
      height: 64,
    );
    c.drawRRect(RRect.fromRectAndRadius(face, const Radius.circular(26)), p);

    c.drawCircle(Offset(s.width / 2 - 46, s.height / 2 + 18), 16, p);
    c.drawCircle(Offset(s.width / 2 + 46, s.height / 2 + 18), 16, p);

    final hair = Paint()..color = const Color(0xFF8A6A00);
    c.drawCircle(Offset(s.width / 2, 10), 3, hair);
    c.drawCircle(Offset(s.width / 2 + 6, 8), 3, hair);

    final eye = Paint()..color = Colors.black;
    c.drawCircle(Offset(s.width / 2 - 16, s.height / 2 + 8), 3.2, eye);
    c.drawCircle(Offset(s.width / 2 + 16, s.height / 2 + 8), 3.2, eye);

    final cheek = Paint()..color = const Color(0xFFFF7BAA);
    c.drawCircle(Offset(s.width / 2 - 26, s.height / 2 + 18), 3, cheek);
    c.drawCircle(Offset(s.width / 2 + 26, s.height / 2 + 18), 3, cheek);

    final beak = Paint()..color = const Color(0xFFFFA23A);
    final path = Path()
      ..moveTo(s.width / 2 - 4, s.height / 2 + 16)
      ..lineTo(s.width / 2 + 4, s.height / 2 + 16)
      ..lineTo(s.width / 2, s.height / 2 + 22)
      ..close();
    c.drawPath(path, beak);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AuthCard extends StatelessWidget {
  final Widget child;
  final Color color;

  const _AuthCard({
    required this.child,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    );
  }
}

class _TextFieldWithHint extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final String rightText;
  final IconData? rightIcon;
  final void Function(String v) onChanged;

  const _TextFieldWithHint({
    required this.controller,
    required this.hint,
    required this.rightText,
    required this.rightIcon,
    required this.onChanged,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF3380EF);

    return Container(
      height: 46,
      padding: const EdgeInsets.only(left: 14, right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: blue, width: 1.2),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey),
              ).copyWith(hintText: hint),
            ),
          ),
          if (rightText.trim().isNotEmpty) ...[
            Text(
              rightText,
              style: const TextStyle(color: blue, fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 8),
          ],
          if (rightIcon != null)
            const Icon(
              Icons.check,
              size: 18,
              color: blue,
            )
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _DropdownBox extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  const _DropdownBox({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF3380EF);

    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: blue, width: 1.2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v == null) return;
            onChanged(v);
          },
        ),
      ),
    );
  }
}

class _LevelSelector extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const _LevelSelector({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF3380EF);

    Widget chip(int v, String t) {
      final selected = value == v;
      return Expanded(
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onChanged(v),
          child: Container(
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? blue : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: blue, width: 1.2),
            ),
            child: Text(
              t,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: selected ? Colors.white : blue,
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip(1, 'Beginner'),
        const SizedBox(width: 10),
        chip(2, 'Intermediate'),
        const SizedBox(width: 10),
        chip(3, 'Pro'),
      ],
    );
  }
}

class _SwitchFooter extends StatelessWidget {
  final bool isSignup;
  final VoidCallback onToggleMode;

  const _SwitchFooter({
    required this.isSignup,
    required this.onToggleMode,
  });

  @override
  Widget build(BuildContext context) {
    const blue = Color(0xFF3380EF);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isSignup ? 'Already have an account?' : 'Don’t have an account?',
          style: const TextStyle(fontSize: 14, color: Colors.black),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onToggleMode,
          child: const Text(
            'Switch',
            style: TextStyle(
              fontSize: 14,
              color: blue,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}
