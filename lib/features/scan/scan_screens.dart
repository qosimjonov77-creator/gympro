import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';
import '../payments/payments_screen.dart';

bool _cameraAsked = false;

/// M-08 (M-07: birinchi skanerda kamera ruxsati oynasi)
class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool ready = _cameraAsked;
  bool handled = false;
  final manual = TextEditingController(text: 'gympro://in?g=demo&t=abc123');

  void _process(String raw) {
    if (handled) return;
    handled = true;
    final r = store.scan(raw);
    if (!mounted) return;
    context.go(r.ok ? '/granted' : '/denied');
  }

  @override
  void initState() {
    super.initState();
    if (!ready) WidgetsBinding.instance.addPostFrameCallback((_) => _askPermission());
  }

  /// M-07
  Future<void> _askPermission() async {
    final ok = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        icon: const Icon(Icons.photo_camera_outlined, size: 36),
        title: const Text('Kamera ruxsati'),
        content: const Text('Zal eshigidagi QR kodni o\'qish uchun kameradan foydalanamiz.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Bekor qilish')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.lime, foregroundColor: AppColors.ink),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Ruxsat berish'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (ok == true) {
      _cameraAsked = true;
      setState(() => ready = true);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.ink,
        appBar: AppBar(
          backgroundColor: AppColors.ink,
          foregroundColor: Colors.white,
          title: const Text('QR\'ni skaner qiling'),
        ),
        body: Column(children: [
          Expanded(
            child: ready
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: MobileScanner(
                      onDetect: (capture) {
                        for (final b in capture.barcodes) {
                          final v = b.rawValue;
                          if (v != null && v.isNotEmpty) {
                            _process(v);
                            return;
                          }
                        }
                      },
                    ),
                  )
                : const SizedBox(),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              top: false,
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Kamera ishlamasa (test rejim): QR matnini kiriting',
                    style: TextStyle(color: AppColors.muted, fontSize: 12)),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(child: TextField(controller: manual)),
                  const SizedBox(width: 10),
                  FilledButton(
                    style: FilledButton.styleFrom(
                        backgroundColor: AppColors.lime,
                        foregroundColor: AppColors.ink,
                        minimumSize: const Size(60, 54)),
                    onPressed: () => _process(manual.text),
                    child: const Text('OK'),
                  ),
                ]),
              ]),
            ),
          ),
        ]),
      );
}

/// M-09
class GrantedScreen extends StatelessWidget {
  const GrantedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final v = store.openVisit;
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            const CircleAvatar(
              radius: 52,
              backgroundColor: AppColors.lime,
              child: Icon(Icons.check_rounded, size: 64, color: AppColors.ink),
            ),
            const SizedBox(height: 24),
            const Text('Kirish qayd etildi',
                style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(v == null ? '' : 'Kirish vaqti: ${fmtTime(v.inAt)}',
                style: const TextStyle(color: Colors.white60, fontSize: 16)),
            const Spacer(),
            LimeButton('Davom etish', onPressed: () => context.go('/inside')),
          ]),
        ),
      ),
    );
  }
}

/// M-10
class DeniedScreen extends StatelessWidget {
  const DeniedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = store.lastScan;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const Spacer(),
            const CircleAvatar(
              radius: 52,
              backgroundColor: Color(0xFFFEE4E2),
              child: Icon(Icons.close_rounded, size: 64, color: AppColors.danger),
            ),
            const SizedBox(height: 24),
            const Text('Kirish rad etildi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text(r?.reason ?? '', textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 16)),
            const Spacer(),
            if (r?.canExtend == true) ...[
              LimeButton('Uzaytirish so\'rovi', icon: Icons.refresh, onPressed: () => showExtendSheet(context)),
              const SizedBox(height: 10),
            ],
            GhostButton('Qayta urinish', onPressed: () => context.go('/scan')),
            const SizedBox(height: 10),
            GhostButton('Bosh sahifa', onPressed: () => context.go('/home')),
          ]),
        ),
      ),
    );
  }
}

/// M-11
class InsideScreen extends StatefulWidget {
  const InsideScreen({super.key});
  @override
  State<InsideScreen> createState() => _InsideScreenState();
}

class _InsideScreenState extends State<InsideScreen> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final v = store.openVisit;
    if (v == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/home');
      });
      return const Scaffold();
    }
    return Scaffold(
      backgroundColor: AppColors.ink,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                color: Colors.white,
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.go('/home'),
              ),
            ),
            const Spacer(),
            const Text('Siz zaldasiz', style: TextStyle(color: AppColors.lime, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),
            Text(fmtDuration(DateTime.now().difference(v.inAt)),
                style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('Kirish: ${fmtTime(v.inAt)}', style: const TextStyle(color: Colors.white60)),
            const Spacer(),
            LimeButton('Chiqish', icon: Icons.logout, onPressed: () => _exit(context)),
          ]),
        ),
      ),
    );
  }

  /// M-12
  Future<void> _exit(BuildContext context) async {
    int rating = 0;
    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (c) => StatefulBuilder(
        builder: (c, setS) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            sheetHandle(),
            const Text('Mashg\'ulot yakunlandimi?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text('Davomiyligi: ${fmtDuration(DateTime.now().difference(store.openVisit!.inAt))}',
                style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 16),
            const Text('Mashg\'ulotni baholang'),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              for (var s = 1; s <= 5; s++)
                IconButton(
                  onPressed: () => setS(() => rating = s),
                  icon: Icon(s <= rating ? Icons.star_rounded : Icons.star_border_rounded,
                      color: AppColors.warn, size: 36),
                ),
            ]),
            const SizedBox(height: 8),
            LimeButton('Chiqishni tasdiqlash', icon: Icons.check, onPressed: () => Navigator.pop(c, true)),
            const SizedBox(height: 8),
            TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Bekor qilish')),
          ]),
        ),
      ),
    );
    if (ok == true) {
      store.checkOut(rating == 0 ? null : rating);
      if (context.mounted) context.go('/home');
    }
  }
}
