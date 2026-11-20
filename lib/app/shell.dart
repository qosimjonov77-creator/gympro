import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';

class MemberShell extends StatelessWidget {
  final Widget child;
  const MemberShell({super.key, required this.child});

  static const _tabs = [
    ('/home', 'Bosh', Icons.home_outlined),
    ('/visits', 'Tashriflar', Icons.calendar_month_outlined),
    ('/payments', 'To\'lovlar', Icons.account_balance_wallet_outlined),
    ('/profile', 'Profil', Icons.person_outline),
  ];

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    Widget tab(int i) {
      final t = _tabs[i];
      final sel = path == t.$1;
      return Expanded(
        child: InkWell(
          onTap: () => context.go(t.$1),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Icon(t.$3, color: sel ? AppColors.ink : AppColors.muted),
              const SizedBox(height: 2),
              Text(t.$2,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      color: sel ? AppColors.ink : AppColors.muted)),
            ]),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(bottom: false, child: child),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.line))),
        child: SafeArea(
          child: Row(children: [
            tab(0),
            tab(1),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/scan'),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  height: 52,
                  decoration: const BoxDecoration(color: AppColors.lime, shape: BoxShape.circle),
                  child: const Icon(Icons.qr_code_scanner, color: AppColors.ink, size: 28),
                ),
              ),
            ),
            tab(2),
            tab(3),
          ]),
        ),
      ),
    );
  }
}
