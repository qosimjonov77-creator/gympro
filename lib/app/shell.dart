import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';

class _Item {
  final String label, path;
  final IconData icon;
  const _Item(this.label, this.path, this.icon);
}

const _items = [
  _Item('Dashboard', '/dashboard', Icons.grid_view_rounded),
  _Item('A\'zolar', '/members', Icons.people_alt_outlined),
  _Item('Obuna sotish', '/sale', Icons.sell_outlined),
  _Item('Tashriflar', '/visits', Icons.login_rounded),
  _Item('Moliya', '/finance', Icons.account_balance_wallet_outlined),
  _Item('Analitika', '/analytics', Icons.bar_chart_rounded),
  _Item('Sozlamalar', '/settings', Icons.settings_outlined),
];

class AdminShell extends StatelessWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: 232,
            color: AppColors.ink,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Row(children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.lime,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.fitness_center, size: 18, color: AppColors.ink),
                  ),
                  const SizedBox(width: 10),
                  const Text('GymPro',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                ]),
                const SizedBox(height: 28),
                for (final it in _items) _NavTile(item: it, selected: path == it.path || path.startsWith('${it.path}/')),
                const Spacer(),
                const Divider(color: Colors.white24),
                const ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.lime,
                    child: Text('DB', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w700)),
                  ),
                  title: Text('Dilshod B.', style: TextStyle(color: Colors.white, fontSize: 14)),
                  subtitle: Text('Administrator', style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
              ],
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final _Item item;
  final bool selected;
  const _NavTile({required this.item, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => context.go(item.path),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: selected ? AppColors.lime : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(children: [
            Icon(item.icon, size: 19, color: selected ? AppColors.ink : Colors.white70),
            const SizedBox(width: 12),
            Text(item.label,
                style: TextStyle(
                  color: selected ? AppColors.ink : Colors.white70,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                )),
          ]),
        ),
      ),
    );
  }
}

/// Hali yasalmagan ekranlar uchun vaqtincha
class Placeholder1 extends StatelessWidget {
  final String title;
  const Placeholder1(this.title, {super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
      );
}
