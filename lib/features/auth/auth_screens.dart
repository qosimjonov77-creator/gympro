import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// M-01
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      if (store.loggedIn) {
        context.go('/home');
      } else if (store.onboarded) {
        context.go('/phone');
      } else {
        context.go('/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        backgroundColor: AppColors.ink,
        body: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.fitness_center, color: AppColors.lime, size: 56),
            SizedBox(height: 14),
            Text('GymPro', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
          ]),
        ),
      );
}

/// M-02
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final page = PageController();
  int i = 0;

  static const slides = [
    (Icons.qr_code_scanner, 'QR bilan kirish', 'Zal eshigidagi QR\'ni telefoningiz bilan skaner qiling, kartasiz kirasiz.'),
    (Icons.event_available, 'Obunangiz nazoratda', 'Obuna holati, qolgan kunlar va to\'lovlaringiz doim qo\'lingizda.'),
    (Icons.notifications_active_outlined, 'O\'z vaqtida eslatma', 'Obuna tugashidan oldin eslatib turamiz.'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Expanded(
                child: PageView(
                  controller: page,
                  onPageChanged: (v) => setState(() => i = v),
                  children: [
                    for (final s in slides)
                      Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                          child: Icon(s.$1, size: 56, color: AppColors.ink),
                        ),
                        const SizedBox(height: 28),
                        Text(s.$2, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 10),
                        Text(s.$3, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 16)),
                      ]),
                  ],
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                for (var k = 0; k < slides.length; k++)
                  Container(
                    margin: const EdgeInsets.all(4),
                    width: k == i ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: k == i ? AppColors.ink : AppColors.line,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
              ]),
              const SizedBox(height: 20),
              LimeButton(i == slides.length - 1 ? 'Boshlash' : 'Keyingisi', onPressed: () {
                if (i == slides.length - 1) {
                  store.finishOnboarding();
                  context.go('/phone');
                } else {
                  page.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
                }
              }),
            ]),
          ),
        ),
      );
}

/// M-03
class PhoneScreen extends StatefulWidget {
  const PhoneScreen({super.key});
  @override
  State<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends State<PhoneScreen> {
  final c = TextEditingController(text: '+998 ');

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              const Text('Telefon raqamingiz', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Zal bazasidagi raqamingizni kiriting. SMS kod yuboramiz.',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 28),
              TextField(
                controller: c,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.phone_outlined)),
              ),
              const Spacer(),
              LimeButton('Kod yuborish', onPressed: () {
                final digits = c.text.replaceAll(RegExp(r'[^0-9]'), '');
                if (digits.length < 12) {
                  toast(context, 'Raqamni to\'liq kiriting (+998 XX XXX XX XX)');
                  return;
                }
                context.go('/sms?p=${Uri.encodeComponent(c.text.trim())}');
              }),
            ]),
          ),
        ),
      );
}

/// M-04
class SmsScreen extends StatefulWidget {
  final String phone;
  const SmsScreen({super.key, required this.phone});
  @override
  State<SmsScreen> createState() => _SmsScreenState();
}

class _SmsScreenState extends State<SmsScreen> {
  final c = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/phone')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('SMS kod', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            Text('${widget.phone} raqamiga 6 xonali kod yuborildi.', style: const TextStyle(color: AppColors.muted)),
            const SizedBox(height: 4),
            const Text('Test rejim: istalgan 6 xonali kod qabul qilinadi.',
                style: TextStyle(color: AppColors.muted, fontSize: 12)),
            const SizedBox(height: 28),
            TextField(
              controller: c,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 28, letterSpacing: 10, fontWeight: FontWeight.w700),
            ),
            const Spacer(),
            LimeButton('Tasdiqlash', onPressed: () {
              if (c.text.trim().length != 6) {
                toast(context, '6 xonali kodni kiriting');
                return;
              }
              context.go('/found?p=${Uri.encodeComponent(widget.phone)}');
            }),
          ]),
        ),
      );
}

/// M-05
class FoundScreen extends StatefulWidget {
  final String phone;
  const FoundScreen({super.key, required this.phone});
  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  final name = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 40),
              const CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.lime,
                child: Icon(Icons.check, size: 34, color: AppColors.ink),
              ),
              const SizedBox(height: 20),
              const Text('Profil topildi', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text('${widget.phone} raqami a\'zo profiliga bog\'landi.', style: const TextStyle(color: AppColors.muted)),
              const SizedBox(height: 24),
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Ismingiz (test rejim)')),
              const SizedBox(height: 6),
              const Text('Firebase ulanganda ism zal bazasidan avtomatik olinadi.',
                  style: TextStyle(fontSize: 12, color: AppColors.muted)),
              const Spacer(),
              LimeButton('Davom etish', onPressed: () {
                store.login(widget.phone, name.text);
                context.go('/home');
              }),
            ]),
          ),
        ),
      );
}
