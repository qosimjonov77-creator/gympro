import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'members_screen.dart';

class MemberProfileScreen extends StatelessWidget {
  final int index;
  const MemberProfileScreen({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final m = mockMembers[index.clamp(0, mockMembers.length - 1)];
    return PageBody(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        TextButton.icon(
          onPressed: () => context.go('/members'),
          icon: const Icon(Icons.arrow_back, size: 18),
          label: const Text('A\'zolar'),
        ),
        PageHeader(m.$1, subtitle: m.$2, actions: [
          GhostButton('Arxivlash', danger: true, onPressed: () => _archive(context, m.$1)),
          if (m.$5 > 0) GhostButton('Qarz to\'lovi', onPressed: () => _payDebt(context, m.$5)),
          LimeButton('Obuna sotish', icon: Icons.sell_outlined, onPressed: () => context.go('/sale')),
        ]),
        Row(children: [
          Expanded(child: Kpi('Tarif', m.$3)),
          const SizedBox(width: 14),
          Expanded(child: Kpi('Tugash sanasi', m.$4)),
          const SizedBox(width: 14),
          Expanded(child: Kpi('Qarz', m.$5 == 0 ? '—' : fmt(m.$5),
              valueColor: m.$5 > 0 ? AppColors.danger : null)),
          const SizedBox(width: 14),
          Expanded(child: AppCard(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Holat', style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 12),
              statusPill(m.$6),
            ]),
          )),
        ]),
        const SizedBox(height: 18),
        DefaultTabController(
          length: 3,
          child: AppCard(
            child: Column(children: [
              const TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                tabs: [Tab(text: 'Obunalar'), Tab(text: 'To\'lovlar'), Tab(text: 'Tashriflar')],
              ),
              SizedBox(
                height: 260,
                child: TabBarView(children: [
                  _list(const [
                    ('12 oylik', '01.07.2026 — 30.06.2027', '3 600 000'),
                    ('1 oylik', '01.06.2026 — 30.06.2026', '300 000'),
                  ]),
                  _list(const [
                    ('Chek №1042', '01.07.2026 · Naqd', '3 600 000'),
                    ('Chek №0961', '01.06.2026 · Karta', '300 000'),
                  ]),
                  _list(const [
                    ('18.11.2026', '09:12 — 10:40', 'Telefon QR'),
                    ('17.11.2026', '18:05 — 19:30', 'Telefon QR'),
                    ('15.11.2026', '07:50 — 09:10', 'Qo\'lda'),
                  ]),
                ]),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _list(List<(String, String, String)> items) => ListView(children: [
        for (final i in items)
          ListTile(
            title: Text(i.$1, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(i.$2),
            trailing: Text(i.$3, style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
      ]);

  /// D-09
  void _payDebt(BuildContext context, int debt) => showAppDialog(context,
      title: 'Qarz to\'lovi',
      confirm: 'To\'lovni qabul qilish',
      body: Column(children: [
        Text('Qarz: ${fmt(debt)} so\'m',
            style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.danger)),
        const SizedBox(height: 12),
        field('Summa', initial: '$debt'),
      ]));

  /// D-10
  Future<void> _archive(BuildContext context, String name) async {
    final ok = await showAppDialog(context,
        title: '$name arxivlansinmi?',
        confirm: 'Arxivlash',
        danger: true,
        body: const Text('A\'zo o\'chirilmaydi, faqat ro\'yxatdan yashiriladi. Tarix saqlanadi.'));
    if (ok == true && context.mounted) context.go('/members');
  }
}
