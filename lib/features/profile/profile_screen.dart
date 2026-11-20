import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// M-18
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          screenTitle('Profil'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppCard(
              child: Row(children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.lime,
                  child: Text(store.name.isEmpty ? '?' : store.name[0].toUpperCase(),
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.ink)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(store.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    Text(store.phone, style: const TextStyle(color: AppColors.muted)),
                  ]),
                ),
              ]),
            ),
          ),
          _title('Eslatma'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Obuna tugashidan necha kun oldin eslatilsin?'),
                const SizedBox(height: 10),
                Wrap(spacing: 8, children: [
                  for (final d in const [1, 3, 7])
                    ChoiceChip(
                      label: Text('$d kun'),
                      selected: store.warnDays == d,
                      selectedColor: AppColors.lime,
                      onSelected: (_) => store.setWarnDays(d),
                    ),
                ]),
              ]),
            ),
          ),
          _title('Demo rejim'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Firebase ulanguncha qabulxona harakatlarini shu yerda sinab ko\'ring.',
                    style: TextStyle(color: AppColors.muted, fontSize: 13)),
                const SizedBox(height: 12),
                GhostButton('Obuna berish (qabulxona o\'rnida)', onPressed: () => _demoSell(context)),
                const SizedBox(height: 8),
                GhostButton('Obunani 2 kunga qisqartirish', onPressed: store.demoExpireSoon),
                const SizedBox(height: 8),
                GhostButton('Obunani tugatish', onPressed: store.demoExpire),
                const SizedBox(height: 8),
                GhostButton('Qarz paydo qilish', onPressed: store.demoDebt),
              ]),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GhostButton('Hisobdan chiqish', danger: true, onPressed: () => _logout(context)),
          ),
        ]),
      );

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
        child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );

  Future<void> _demoSell(BuildContext context) async {
    final p = await showDialog<Plan>(
      context: context,
      builder: (c) => SimpleDialog(
        title: const Text('Tarifni tanlang'),
        children: [
          for (final p in store.plans)
            SimpleDialogOption(onPressed: () => Navigator.pop(c, p), child: Text('${p.name} · ${fmt(p.price)} so\'m')),
        ],
      ),
    );
    if (p != null) store.demoSell(p);
  }

  /// M-19
  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Hisobdan chiqasizmi?'),
        content: const Text('Ilovadagi saqlangan ma\'lumotlar tozalanadi.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Bekor qilish')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Chiqish'),
          ),
        ],
      ),
    );
    if (ok == true) {
      store.logout();
      if (context.mounted) context.go('/phone');
    }
  }
}
