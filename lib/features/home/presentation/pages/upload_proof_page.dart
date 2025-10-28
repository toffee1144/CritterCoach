import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:critter_care/features/home/presentation/pages/verifying_proof_page.dart';
import 'dart:convert';

/// UploadProofPage — Full-Layout + Tweaks + HTTP multipart
class UploadProofPage extends StatefulWidget {
  final String itemId;
  final String itemTitle;
  final String itemType; // "habit" or "task"

  const UploadProofPage({
    super.key,
    required this.itemId,
    required this.itemTitle,
    required this.itemType,
  });

  @override
  State<UploadProofPage> createState() => _UploadProofPageState();
}

class _UploadProofPageState extends State<UploadProofPage> {
  final _t = _Tweaks();
  final ImagePicker _picker = ImagePicker();

  Uint8List? _previewBytes;
  String? _pickedFileName;

  bool _uploading = false;

  // ==== CONFIG SERVER ====
  // ANDROID EMULATOR? ganti ke 10.0.2.2
  static const String _baseUrl = 'http://72.60.79.89:5001';
  static const String _endpoint = '/proofs/upload';

  Future<void> _pick(ImageSource src) async {
    try {
      final XFile? file = await _picker.pickImage(
        source: src,
        maxWidth: 2048,
        imageQuality: 85,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      setState(() {
        _previewBytes = bytes;
        _pickedFileName = file.name;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _clearPreview() => setState(() {
        _previewBytes = null;
        _pickedFileName = null;
      });

  /// Kirim bytes gambar + metadata via Multipart
  Future<({int status, String body})> _sendProof({
    required Uint8List bytes,
    required String filename,
    required String mime,
  }) async {
    final uri = Uri.parse('$_baseUrl$_endpoint');
    final req = http.MultipartRequest('POST', uri)
      ..fields['item_id'] = widget.itemId
      ..fields['item_title'] = widget.itemTitle
      ..fields['item_type'] = widget.itemType
      ..files.add(
        http.MultipartFile.fromBytes(
          'file', // harus sama dengan key di Flask: request.files['file']
          bytes,
          filename: filename,
          contentType: MediaType.parse(mime),
        ),
      );

    // contoh auth:
    // req.headers['Authorization'] = 'Bearer <token>';

    final streamed = await req.send();
    final body = await streamed.stream.bytesToString();
    return (status: streamed.statusCode, body: body);
  }

  /// Wrapper: tampilkan overlay verifying, kirim, handle hasil
  Future<void> _uploadImageBytes(Uint8List bytes, {String? filename}) async {
    setState(() => _uploading = true);
    try {
      final mimeType =
          lookupMimeType(filename ?? 'proof.jpg', headerBytes: bytes) ?? 'image/jpeg';
      final safeName =
          filename ?? 'proof_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // ✅ Definisikan verify() yang akan dipakai di VerifyingProofPage
      Future<VerifyOutcome> verify() async {
        final res = await _sendProof(bytes: bytes, filename: safeName, mime: mimeType);

        // 1) Basic HTTP guard
        if (res.status < 200 || res.status >= 300) {
          // Biarkan VerifyingProofPage melakukan retry/timeout logic,
          // tapi kita lempar error agar tidak dianggap "pass".
          throw Exception('HTTP ${res.status}: ${res.body}');
        }

        // 2) Parse JSON robustly
        Map<String, dynamic> data;
        try {
          final decoded = jsonDecode(res.body);
          data = (decoded is Map<String, dynamic>) ? decoded : <String, dynamic>{};
        } catch (e) {
          throw Exception('Invalid JSON: ${res.body}');
        }

        // 3) Read pass (bool OR string "true")
        bool pass = false;
        final rawPass = data['pass'];
        if (rawPass is bool) {
          pass = rawPass;
        } else if (rawPass is String) {
          pass = rawPass.toLowerCase() == 'true';
        }

        // 4) Optional rewards (accept multiple shapes: flat or nested)
        int xp = 0, bonus = 0, coins = 0;

        // flat
        xp = (data['xp'] is num) ? (data['xp'] as num).toInt() : xp;
        bonus = (data['bonus'] is num) ? (data['bonus'] as num).toInt() : bonus;
        coins = (data['coins'] is num) ? (data['coins'] as num).toInt() : coins;

        // nested (e.g., {"rewards":{"xp":..,"bonus":..,"coins":..}})
        final rewards = data['rewards'];
        if (rewards is Map) {
          xp = (rewards['xp'] is num) ? (rewards['xp'] as num).toInt() : xp;
          bonus = (rewards['bonus'] is num) ? (rewards['bonus'] as num).toInt() : bonus;
          coins = (rewards['coins'] is num) ? (rewards['coins'] as num).toInt() : coins;
        }

        // 5) Return the exact object VerifyingProofPage expects
        return VerifyOutcome(pass: pass, xp: xp, bonus: bonus, coins: coins);
      }


      // ✅ Dorong halaman verifikasi — dia yang akan redirect
      // inside UploadProofPage, when you push VerifyingProofPage:
      Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (_, __, ___) => VerifyingProofPage(
            preview: MemoryImage(bytes),
            verify: () async {
              final t0 = DateTime.now();
              print('[verify()] start upload...');

              final res = await _sendProof(bytes: bytes, filename: safeName, mime: mimeType);

              final ms = DateTime.now().difference(t0).inMilliseconds;
              print('[verify()] http=${res.status} in ${ms}ms');
              print('[verify()] rawBody=${res.body}');

              if (res.status < 200 || res.status >= 300) {
                print('[verify()] non-2xx -> throw');
                throw Exception('HTTP ${res.status}');
              }

              Map<String, dynamic> data;
              try {
                final d = jsonDecode(res.body);
                data = d is Map<String, dynamic> ? d : <String, dynamic>{};
              } catch (e) {
                print('[verify()] JSON parse error: $e');
                throw Exception('Invalid JSON');
              }

              // ---- CRITICAL: use validation.pass first, then fallback to root pass
              bool pass = false;

              final v = data['validation'];
              if (v is Map<String, dynamic>) {
                final raw = v['pass'];
                if (raw is bool) pass = raw;
                if (raw is String) pass = raw.toLowerCase() == 'true';
              }

              if (!pass && data.containsKey('pass')) {
                final raw = data['pass'];
                if (raw is bool) pass = raw;
                if (raw is String) pass = raw.toLowerCase() == 'true';
              }

              int xp = 0, bonus = 0, coins = 0;
              final rewards = data['rewards'];
              if (rewards is Map) {
                if (rewards['xp'] is num) xp = (rewards['xp'] as num).toInt();
                if (rewards['bonus'] is num) bonus = (rewards['bonus'] as num).toInt();
                if (rewards['coins'] is num) coins = (rewards['coins'] as num).toInt();
              } else {
                if (data['xp'] is num) xp = (data['xp'] as num).toInt();
                if (data['bonus'] is num) bonus = (data['bonus'] as num).toInt();
                if (data['coins'] is num) coins = (data['coins'] as num).toInt();
              }

              print('[verify()] parsed => pass=$pass, xp=$xp, bonus=$bonus, coins=$coins');

              return VerifyOutcome(pass: pass, xp: xp, bonus: bonus, coins: coins);
            },

            // you can keep these long timeouts if you really need them:
            minScreenTime: const Duration(seconds: 2),   // UX—your log shows 2s anyway
            verifyTimeout: const Duration(seconds: 120),
            verifyRetries: 1,
            fallbackWhenError: false,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload error: $e')),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final w = sz.width, h = sz.height;

    final sidePad = w * _t.sidePadPct;
    final topPad = h * _t.topPadPct;
    final titleGap = h * _t.titleGapPct;

    final creatureSize = w * _t.creatureSizePct;
    final creatureTop = h * _t.creatureTopPct;
    final bubbleGap = h * _t.bubbleGapPct;

    final uploadH = h * _t.uploadHeightPct;
    final uploadRad = w * _t.uploadRadiusPct;

    final sideIcon = w * _t.sideIconPct;
    final centerIcon = w * _t.centerIconPct;

    final btnRadius = w * _t.buttonRadiusPct;
    final btnH = h * _t.buttonHeightPct;
    final bottomGap = h * _t.bottomGapPct;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openTweaks,
        icon: const Icon(Icons.tune_rounded),
        label: const Text('Tweak'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.16, 1.0],
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF69E)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(builder: (context, c) {
            return Stack(children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(sidePad, topPad, sidePad, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        'Upload Your Proof',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF163A76),
                            ),
                      ),
                      SizedBox(height: titleGap),

                      _BubblesAndCreature(
                        creatureSize: creatureSize,
                        creatureTop: creatureTop,
                        bubbleGap: bubbleGap,
                        sidePad: sidePad,
                      ),

                      const SizedBox(height: 8),

                      _UploadArea(
                        height: uploadH,
                        radius: uploadRad,
                        sideIconSize: sideIcon,
                        centerIconSize: centerIcon,
                        previewBytes: _previewBytes,
                        onPickCamera: () => _pick(ImageSource.camera),
                        onPickGallery: () => _pick(ImageSource.gallery),
                        onClear: _clearPreview,
                      ),

                      SizedBox(height: btnH + bottomGap + 12),
                    ],
                  ),
                ),
              ),

              // Submit bottom button
              Positioned(
                left: sidePad,
                right: sidePad,
                bottom: bottomGap,
                child: _GradientButton(
                  label: _uploading ? 'Uploading...' : 'Submit',
                  height: btnH,
                  radius: btnRadius,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD14A), Color(0xFFFF9800)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  onPressed: _uploading
                      ? null
                      : () async {
                          if (_previewBytes == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please pick an image first.')),
                            );
                            return;
                          }
                          await _uploadImageBytes(
                            _previewBytes!,
                            filename: _pickedFileName ?? 'proof.jpg',
                          );
                        },
                ),
              ),
            ]);
          }),
        ),
      ),
    );
  }

  void _openTweaks() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: .8,
        minChildSize: .4,
        maxChildSize: .95,
        builder: (_, ctrl) => ListView(
          controller: ctrl,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            Row(children: [
              const Icon(Icons.tune_rounded), const SizedBox(width: 8),
              Text('Tweak Panel (full layout)',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              IconButton(
                  onPressed: () => setState(_t.reset),
                  icon: const Icon(Icons.refresh_rounded)),
            ]),
            const SizedBox(height: 8),

            // Spacing / paddings
            _Knob(label: 'Page side pad (w%)', v: _t.sidePadPct, min: .03, max: .08,
                on: (v) => setState(() => _t.sidePadPct = v)),
            _Knob(label: 'Top pad (h%)', v: _t.topPadPct, min: .01, max: .04,
                on: (v) => setState(() => _t.topPadPct = v)),
            _Knob(label: 'Title→bubbles gap (h%)', v: _t.titleGapPct, min: .006, max: .04,
                on: (v) => setState(() => _t.titleGapPct = v)),

            // Creature + bubbles
            _Knob(label: 'Creature size (w%)', v: _t.creatureSizePct, min: .16, max: .38,
                on: (v) => setState(() => _t.creatureSizePct = v)),
            _Knob(label: 'Creature top over bubbles (h%)', v: _t.creatureTopPct, min: -.02, max: .10,
                on: (v) => setState(() => _t.creatureTopPct = v)),
            _Knob(label: 'Bubble gap (h%)', v: _t.bubbleGapPct, min: .0, max: .04,
                on: (v) => setState(() => _t.bubbleGapPct = v)),

            // Upload card
            _Knob(label: 'Upload height (h%)', v: _t.uploadHeightPct, min: .26, max: .55,
                on: (v) => setState(() => _t.uploadHeightPct = v)),
            _Knob(label: 'Upload radius (w%)', v: _t.uploadRadiusPct, min: .02, max: .07,
                on: (v) => setState(() => _t.uploadRadiusPct = v)),

            // Icon sizes
            _Knob(label: 'Side icon size (w%)', v: _t.sideIconPct, min: .08, max: .16,
                on: (v) => setState(() => _t.sideIconPct = v)),
            _Knob(label: 'Center icon size (w%)', v: _t.centerIconPct, min: .14, max: .30,
                on: (v) => setState(() => _t.centerIconPct = v)),

            // Button
            _Knob(label: 'Button radius (w%)', v: _t.buttonRadiusPct, min: .02, max: .07,
                on: (v) => setState(() => _t.buttonRadiusPct = v)),
            _Knob(label: 'Button height (h%)', v: _t.buttonHeightPct, min: .055, max: .09,
                on: (v) => setState(() => _t.buttonHeightPct = v)),
            _Knob(label: 'Button bottom safe gap (h%)', v: _t.bottomGapPct, min: .012, max: .05,
                on: (v) => setState(() => _t.bottomGapPct = v)),
          ],
        ),
      ),
    );
  }
}

/// ——— Widgets ———

class _BubblesAndCreature extends StatelessWidget {
  const _BubblesAndCreature({
    required this.creatureSize,
    required this.creatureTop,
    required this.bubbleGap,
    required this.sidePad,
  });

  final double creatureSize;
  final double creatureTop;
  final double bubbleGap;
  final double sidePad;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return SizedBox(
      height: creatureSize * 0.9 + 72,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const _SpeechBubbleLeft(
                  text: 'Please upload your proof of activity\n'
                      'to get verifies by our AI!',
                ),
                SizedBox(height: bubbleGap),
                const _SpeechBubbleLeft(
                  text: "*Don't upload pictures contains any faces\n"
                      "or personal data for safety.",
                ),
              ],
            ),
          ),
          Positioned(
            left: (w - sidePad * 2 - creatureSize) / 2,
            top: creatureTop,
            child: SvgPicture.asset(
              'assets/global/icons/creature.svg',
              width: creatureSize,
              height: creatureSize,
              semanticsLabel: 'Creature',
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadArea extends StatelessWidget {
  const _UploadArea({
    required this.height,
    required this.radius,
    required this.sideIconSize,
    required this.centerIconSize,
    required this.previewBytes,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onClear,
  });

  final double height;
  final double radius;
  final double sideIconSize;
  final double centerIconSize;

  final Uint8List? previewBytes;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasPreview = previewBytes != null;

    return Container(
      height: height,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 8))
        ],
        border: Border.all(color: const Color(0xFFE7E7E7)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 4),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (hasPreview) Image.memory(previewBytes!, fit: BoxFit.cover),

            if (!hasPreview)
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CircleIcon(
                      icon: Icons.refresh_rounded,
                      size: sideIconSize,
                      onTap: () {},
                    ),
                    _CircleIcon(
                      icon: Icons.photo_camera_rounded,
                      size: centerIconSize,
                      isPrimary: true,
                      onTap: onPickCamera,
                    ),
                    _CircleIcon(
                      icon: Icons.photo_library_rounded,
                      size: sideIconSize,
                      onTap: onPickGallery,
                    ),
                  ],
                ),
              ),

            if (hasPreview)
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.black.withOpacity(.45),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onClear,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.close_rounded, color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SpeechBubbleLeft extends StatelessWidget {
  const _SpeechBubbleLeft({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const double tailW = 18;
    return Transform.translate(
      offset: const Offset(-tailW / 2, 0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, 6)),
              ],
            ),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12.5, height: 1.25, color: Color(0xFF1F1F1F)),
            ),
          ),
          const Positioned(
            left: 18,
            bottom: -10,
            child: _BubbleTailLeft(),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailLeft extends StatelessWidget {
  const _BubbleTailLeft();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: const Size(18, 12), painter: _BubbleTailPainterLeft());
  }
}

class _BubbleTailPainterLeft extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width * .35, size.height)
      ..close();
    final shadowPath = Path.from(path)..shift(const Offset(0, 2));
    canvas.drawShadow(shadowPath, const Color(0xFF000000), 3, false);
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircleIcon extends StatelessWidget {
  const _CircleIcon({
    required this.icon,
    this.size = 40,
    this.isPrimary = false,
    this.onTap,
  });
  final IconData icon;
  final double size;
  final bool isPrimary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = isPrimary ? const Color(0xFFF0F0F0) : const Color(0xFFF5F5F5);
    final fg = isPrimary ? const Color(0xFF9E9E9E) : const Color(0xFF6F6F6F);
    return InkResponse(
      onTap: onTap,
      radius: size / 2 + 6,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Icon(icon, color: fg, size: size * .55),
      ),
    );
  }
}

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    required this.onPressed,
    required this.label,
    required this.gradient,
    this.icon,
    this.radius = 16,
    this.height = 52,
  });

  final VoidCallback? onPressed;
  final String label;
  final LinearGradient gradient;
  final Widget? icon;
  final double radius;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: const [
          BoxShadow(color: Color(0x20000000), blurRadius: 10, offset: Offset(0, 6))
        ],
      ),
      child: Opacity(
        opacity: enabled ? 1 : .6,
        child: SizedBox(
          height: height,
          width: double.infinity,
          child: TextButton.icon(
            onPressed: onPressed,
            icon: icon ?? const SizedBox.shrink(),
            label: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF1F1F1F),
                fontWeight: FontWeight.w800,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF1F1F1F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tweaks {
  double sidePadPct = .044;
  double topPadPct = .018;
  double titleGapPct = .016;

  double creatureSizePct = .380;
  double creatureTopPct = .190;
  double bubbleGapPct = .012;

  double uploadHeightPct = .34;
  double uploadRadiusPct = .04;

  double sideIconPct = .10;
  double centerIconPct = .18;

  double buttonRadiusPct = .04;
  double buttonHeightPct = .07;
  double bottomGapPct = .02;

  void reset() {
    sidePadPct = .044;
    topPadPct = .018;
    titleGapPct = .016;
    creatureSizePct = .22;
    creatureTopPct = .06;
    bubbleGapPct = .012;
    uploadHeightPct = .34;
    uploadRadiusPct = .04;
    sideIconPct = .10;
    centerIconPct = .18;
    buttonRadiusPct = .04;
    buttonHeightPct = .07;
    bottomGapPct = .02;
  }
}

class _Knob extends StatelessWidget {
  const _Knob({
    required this.label,
    required this.v,
    required this.min,
    required this.max,
    required this.on,
  });
  final String label;
  final double v;
  final double min;
  final double max;
  final ValueChanged<double> on;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 180, child: Text(label, overflow: TextOverflow.ellipsis)),
          Expanded(child: Slider(value: v.clamp(min, max), min: min, max: max, onChanged: on)),
          SizedBox(width: 64, child: Text(v.toStringAsFixed(3), textAlign: TextAlign.end)),
        ]),
      );
}
