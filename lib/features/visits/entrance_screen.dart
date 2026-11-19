import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../app/theme.dart';

/// D-14: eshikdagi ekran, har 30 soniyada yangi QR (hozircha soxta token)
class EntranceScreen extends StatefulWidget {
  const EntranceScreen({super.key});
  @override
  State<EntranceScreen> createState() => _EntranceScreenState();
}

class _EntranceScreenState extends State<EntranceScreen> {
  static const _chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final _rnd = Random();
  late String token = _newToken();
  int left = 30;
  Timer? _timer;

  String _newToken() => List.generate(16, (_) => _chars[_rnd.nextInt(_chars.length)]).join();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        left--;
        if (left <= 0) {
          left = 30;
          token = _newToken();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.ink,
        body: Stack(children: [
          Positioned(
            top: 16,
            left: 16,
            child: IconButton(
              color: Colors.white54,
              onPressed: () => context.go('/visits'),
              icon: const Icon(Icons.close),
            ),
          ),
          Center(
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const SizedBox(
                width: 380,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                  Text('Xush kelibsiz!',
                      style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w800)),
                  SizedBox(height: 8),
                  Text('Telefoningiz bilan skaner qiling',
                      style: TextStyle(color: AppColors.lime, fontSize: 22, fontWeight: FontWeight.w600)),
                  SizedBox(height: 20),
                  Text('GymPro Member ilovasida "QR\'ni skaner qilish" tugmasini bosing.',
                      style: TextStyle(color: Colors.white60, fontSize: 15)),
                ]),
              ),
              const SizedBox(width: 60),
              Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: QrImageView(data: 'gympro://in?g=chilonzor&t=$token', size: 260),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: 296,
                  child: LinearProgressIndicator(
                    value: left / 30,
                    color: AppColors.lime,
                    backgroundColor: Colors.white24,
                  ),
                ),
                const SizedBox(height: 6),
                Text('$left s ichida yangilanadi', style: const TextStyle(color: Colors.white54)),
              ]),
            ]),
          ),
        ]),
      );
}
