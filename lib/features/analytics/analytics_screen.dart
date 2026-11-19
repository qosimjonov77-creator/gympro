import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  // (oy, tushum, xarajat) mln so'm
  static const months = [
    ('Yan', 38, 22), ('Fev', 41, 23), ('Mar', 44, 25), ('Apr', 40, 24),
    ('May', 47, 26), ('Iyn', 52, 27), ('Iyl', 49, 27), ('Avg', 45, 26),
    ('Sen', 54, 28), ('Okt', 58, 30), ('Noy', 62, 31),
  ];

  @override
  Widget build(BuildContext context) {
    const maxV = 62.0;
    return PageBody(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PageHeader('Analitika', subtitle: '2026'),
        const Row(children: [
          Expanded(child: Kpi('Yillik tushum', '530 mln')),
          SizedBox(width: 14),
          Expanded(child: Kpi('Yillik xarajat', '289 mln')),
          SizedBox(width: 14),
          Expanded(child: Kpi('Sof foyda', '241 mln', valueColor: AppColors.ok)),
          SizedBox(width: 14),
          Expanded(child: Kpi('Yangilanish', '77%')),
        ]),
        const SizedBox(height: 16),
        AppCard(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Oylar bo\'yicha tushum va xarajat',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 18),
            SizedBox(
              height: 220,
              child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                for (final m in months)
                  Expanded(
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Row(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
                        _bar(180 * m.$2 / maxV, AppColors.ink),
                        const SizedBox(width: 3),
                        _bar(180 * m.$3 / maxV, AppColors.lime),
                      ]),
                      const SizedBox(height: 6),
                      Text(m.$1, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
                    ]),
                  ),
              ]),
            ),
            const SizedBox(height: 10),
            const Row(children: [
              Icon(Icons.circle, size: 10, color: AppColors.ink),
              SizedBox(width: 6),
              Text('Tushum'),
              SizedBox(width: 16),
              Icon(Icons.circle, size: 10, color: AppColors.lime),
              SizedBox(width: 6),
              Text('Xarajat'),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _bar(double h, Color c) => Container(
        width: 16,
        height: h,
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(4)),
      );
}
