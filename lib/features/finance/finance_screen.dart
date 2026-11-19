import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';

class FinanceScreen extends StatelessWidget {
  const FinanceScreen({super.key});

  // Soxta kunlik statistika: (kun, tashrif, obuna, bir martalik, xarajat)
  static final days = [
    for (var d = 19; d >= 1; d--)
      (d, 40 + (d * 7) % 25, 1200000 + (d * 91000) % 900000, 60000 + (d * 13000) % 120000, 150000 + (d * 37000) % 300000)
  ];

  @override
  Widget build(BuildContext context) {
    var profit = 0;
    for (final d in days) {
      profit += d.$3 + d.$4 - d.$5;
    }
    return PageBody(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader('Moliya', subtitle: 'Noyabr 2026', actions: [
          GhostButton('Eksport', onPressed: () => _export(context)),
          GhostButton('Xarajat', onPressed: () => _expense(context)),
          GhostButton('To\'lovni bekor qilish', danger: true, onPressed: () => _cancel(context)),
          LimeButton('Kunni yopish', icon: Icons.lock_outline, onPressed: () => _closeDay(context)),
        ]),
        AppCard(
          color: AppColors.ink,
          child: Row(children: [
            Expanded(child: _dark('Oy boshidan foyda', fmt(profit), AppColors.lime)),
            Expanded(child: _dark('Naqd', '21 140 000', Colors.white)),
            Expanded(child: _dark('Karta', '12 300 000', Colors.white)),
            Expanded(child: _dark('O\'tkazma', '5 180 000', Colors.white)),
          ]),
        ),
        const SizedBox(height: 16),
        DataGrid(
          headers: const ['Kun', 'Tashrif', 'Obuna', 'Bir martalik', 'Xarajat', 'Foyda'],
          flex: const [2, 1, 2, 2, 2, 2],
          rows: [
            for (final d in days)
              [
                t('${d.$1.toString().padLeft(2, '0')}.11', bold: true),
                t('${d.$2}'),
                t(fmt(d.$3)),
                t(fmt(d.$4)),
                t(fmt(d.$5)),
                t(fmt(d.$3 + d.$4 - d.$5), bold: true, color: AppColors.ok),
              ],
          ],
        ),
      ]),
    );
  }

  Widget _dark(String a, String b, Color c) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(a, style: const TextStyle(color: Colors.white60)),
        const SizedBox(height: 6),
        Text(b, style: TextStyle(color: c, fontSize: 26, fontWeight: FontWeight.w800)),
      ]);

  /// D-19
  void _expense(BuildContext context) => showAppDialog(context,
      title: 'Xarajat qo\'shish',
      body: Column(children: [field('Toifa (ijara, kommunal, maosh...)'), field('Summa'), field('Izoh')]));

  /// D-20
  void _closeDay(BuildContext context) => showAppDialog(context,
      title: 'Kunni yopish',
      confirm: 'Kunni yopish',
      body: Column(children: [
        const Text('Ochiq tashriflar yopiladi. Yopilgan kunni faqat egasi qayta ochadi.'),
        const SizedBox(height: 12),
        field('Sanalgan naqd pul'),
      ]));

  /// D-21
  void _cancel(BuildContext context) => showAppDialog(context,
      title: 'To\'lovni bekor qilish',
      confirm: 'Bekor qilish',
      cancel: 'Yopish',
      danger: true,
      body: Column(children: [
        const Text('Chek №1042 · 300 000 so\'m'),
        const SizedBox(height: 12),
        field('Sabab (majburiy)'),
      ]));

  /// D-22
  void _export(BuildContext context) => showAppDialog(context,
      title: 'Eksport',
      confirm: 'Yuklab olish',
      body: Column(children: [
        RadioGroupLike(),
      ]));
}

class RadioGroupLike extends StatelessWidget {
  const RadioGroupLike({super.key});
  @override
  Widget build(BuildContext context) => const Column(children: [
        ListTile(leading: Icon(Icons.table_chart_outlined), title: Text('Excel (.xlsx)'), subtitle: Text('6 varaq')),
        ListTile(leading: Icon(Icons.picture_as_pdf_outlined), title: Text('PDF')),
      ]);
}
