import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  static const log = [
    ('10:21', 'Nodira Ergasheva', 'Telefon QR', 'Zalda', 'ok'),
    ('10:05', 'Sardor Aliyev', 'Telefon QR', 'Zalda', 'ok'),
    ('09:58', 'Bobur Yusupov', 'Telefon QR', 'Rad etildi: obuna tugagan', 'denied'),
    ('09:40', 'Madina Rahimova', 'Qo\'lda', '09:40 — 10:55', 'ok'),
    ('09:12', 'Jasur Toshpulatov', 'Telefon QR', 'Zalda', 'ok'),
  ];

  @override
  Widget build(BuildContext context) => PageBody(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PageHeader('Tashriflar', subtitle: 'Bugungi jonli jurnal', actions: [
            GhostButton('Kirish ekrani (QR)', onPressed: () => context.go('/entrance')),
            LimeButton('Bir martalik', onPressed: () => _oneTime(context)),
          ]),
          const Row(children: [
            Expanded(child: Kpi('Bugun tashrif', '63')),
            SizedBox(width: 14),
            Expanded(child: Kpi('Hozir zalda', '18')),
            SizedBox(width: 14),
            Expanded(child: Kpi('Rad etilgan', '2', valueColor: AppColors.danger)),
          ]),
          const SizedBox(height: 16),
          AppCard(
            child: Row(children: [
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Qo\'lda check-in: telefoni yo\'q a\'zoni qidiring',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GhostButton('Tugagan obunani sinash', onPressed: () => _expired(context)),
            ]),
          ),
          const SizedBox(height: 16),
          DataGrid(
            headers: const ['Vaqt', 'A\'zo', 'Usul', 'Holat'],
            flex: const [1, 3, 2, 3],
            rows: [
              for (final v in log)
                [
                  t(v.$1),
                  t(v.$2, bold: true),
                  t(v.$3),
                  v.$5 == 'denied' ? Pill(v.$4, AppColors.danger) : t(v.$4),
                ],
            ],
          ),
        ]),
      );

  /// D-16
  void _expired(BuildContext context) => showAppDialog(context,
      title: 'Obuna muddati tugagan',
      confirm: 'Uzaytirish',
      cancel: 'Bir martalik tashrif',
      body: const Text('Bobur Yusupov: obuna 10.11.2026 da tugagan.\nUzaytirasizmi yoki bir martalik tashrifmi?'));

  /// D-17
  void _oneTime(BuildContext context) => showAppDialog(context,
      title: 'Bir martalik mehmon',
      confirm: 'To\'lovni qabul qilish',
      body: Column(children: [field('Ism'), field('Summa', initial: '30000')]));
}
