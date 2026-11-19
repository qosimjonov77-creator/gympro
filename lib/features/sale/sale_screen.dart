import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';

/// Hisob-kitob qoidasi: tugash = boshlanish + (kunlar - 1)
DateTime subEnd(DateTime start, int days) => start.add(Duration(days: days - 1));

class SaleScreen extends StatefulWidget {
  const SaleScreen({super.key});
  @override
  State<SaleScreen> createState() => _SaleScreenState();
}

class _SaleScreenState extends State<SaleScreen> {
  static const plans = [
    ('1 oylik', 30, 300000),
    ('3 oylik', 90, 800000),
    ('6 oylik', 180, 1500000),
    ('12 oylik', 365, 2700000),
  ];
  int plan = 0;
  String method = 'Naqd';
  final start = DateTime(2026, 11, 19);
  late final paid = TextEditingController(text: '300000');

  @override
  Widget build(BuildContext context) {
    final p = plans[plan];
    final paidN = int.tryParse(paid.text.replaceAll(' ', '')) ?? 0;
    final debt = (p.$3 - paidN).clamp(0, p.$3);
    final end = subEnd(start, p.$2);

    return PageBody(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PageHeader('Obuna sotish'),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 3,
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('1. A\'zo', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  field('Qidirish (ism yoki telefon)', initial: 'Madina Rahimova'),
                ]),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('2. Tarif', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    for (var i = 0; i < plans.length; i++)
                      InkWell(
                        onTap: () => setState(() {
                          plan = i;
                          paid.text = '${plans[i].$3}';
                        }),
                        child: Container(
                          width: 150,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: i == plan ? AppColors.lime : Colors.white,
                            border: Border.all(color: i == plan ? AppColors.ink : AppColors.line),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(plans[i].$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('${fmt(plans[i].$3)} so\'m'),
                          ]),
                        ),
                      ),
                  ]),
                ]),
              ),
              const SizedBox(height: 14),
              AppCard(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('3. To\'lov', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  ChipsRow(
                    items: const ['Naqd', 'Karta', 'O\'tkazma'],
                    selected: method,
                    onChanged: (v) => setState(() => method = v),
                  ),
                  const SizedBox(height: 14),
                  field('To\'lanayotgan summa', c: paid),
                ]),
              ),
            ]),
          ),
          const SizedBox(width: 18),
          Expanded(
            flex: 2,
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Xulosa', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
                const SizedBox(height: 14),
                _row('Tarif', p.$1),
                _row('Boshlanish', fmtDate(start)),
                _row('Tugash', fmtDate(end)),
                _row('Narx', fmt(p.$3)),
                _row('To\'lanadi', fmt(paidN)),
                _row('Qarz', fmt(debt), color: debt > 0 ? AppColors.danger : null),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: LimeButton('Sotishni tasdiqlash', icon: Icons.check, onPressed: () => _confirm(context, p, end, paidN)),
                ),
              ]),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _row(String a, String b, {Color? color}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(a, style: const TextStyle(color: AppColors.muted)),
          Text(b, style: TextStyle(fontWeight: FontWeight.w700, color: color)),
        ]),
      );

  /// D-12 -> D-13
  Future<void> _confirm(BuildContext context, (String, int, int) p, DateTime end, int paidN) async {
    final ok = await showAppDialog(context,
        title: 'Sotuvni tasdiqlang',
        confirm: 'Tasdiqlash',
        body: Text('${p.$1} · ${fmtDate(start)} — ${fmtDate(end)}\nTo\'lov: ${fmt(paidN)} so\'m ($method)'));
    if (ok == true && context.mounted) {
      await showAppDialog(context,
          title: 'Chek №1043',
          confirm: 'Chop etish',
          cancel: 'Yopish',
          body: Text('Madina Rahimova\n${p.$1}\n${fmtDate(start)} — ${fmtDate(end)}\nTo\'langan: ${fmt(paidN)} so\'m'));
    }
  }
}
