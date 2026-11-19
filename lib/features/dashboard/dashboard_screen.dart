import 'package:flutter/material.dart';
import '../../app/theme.dart';

// Vaqtincha soxta ma'lumotlar. Keyin Riverpod provider'lardan keladi.
const _last14 = [18, 22, 15, 27, 30, 24, 12, 26, 31, 28, 35, 29, 20, 38]; // ming so'm
const _inside = [
  ('Jasur Toshpulatov', 'Ertalabki guruh', '09:12'),
  ('Madina Rahimova', '3 oylik', '09:40'),
  ('Sardor Aliyev', '1 oylik', '10:05'),
  ('Nodira Ergasheva', '12 oylik', '10:21'),
];
const _alerts = [
  ('Aziz Karimov', 'Obuna 2 kunda tugaydi', AppColors.warn),
  ('Bobur Yusupov', 'Obuna tugagan', AppColors.danger),
  ('Malika Sodiqova', 'Qarz: 150 000 so\'m', AppColors.danger),
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Xayrli kun, Dilshod',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('19-noyabr 2026 · Chilonzor filiali', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 22),
          Row(children: const [
            Expanded(child: _Kpi('Faol a\'zolar', '324', Icons.people_alt_outlined)),
            SizedBox(width: 14),
            Expanded(child: _Kpi('Hozir zalda', '${4}', Icons.login_rounded)),
            SizedBox(width: 14),
            Expanded(child: _Kpi('Bugungi tushum', '2 430 000', Icons.payments_outlined)),
            SizedBox(width: 14),
            Expanded(child: _Kpi('Qarzdorlik', '2 250 000', Icons.warning_amber_rounded)),
          ]),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 3, child: _Chart()),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: AppCard(
                  color: AppColors.ink,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Noyabr 2026', style: TextStyle(color: Colors.white60)),
                      SizedBox(height: 8),
                      Text('38 620 000',
                          style: TextStyle(color: AppColors.lime, fontSize: 30, fontWeight: FontWeight.w800)),
                      Text('oy boshidan foyda', style: TextStyle(color: Colors.white60)),
                      SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Hozir zalda', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 10),
                      for (final m in _inside)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.bg,
                            child: Text(m.$1[0], style: const TextStyle(color: AppColors.ink)),
                          ),
                          title: Text(m.$1),
                          subtitle: Text(m.$2),
                          trailing: Text(m.$3, style: const TextStyle(color: AppColors.muted)),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Diqqat', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                      const SizedBox(height: 10),
                      for (final a in _alerts)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(Icons.circle, size: 10, color: a.$3),
                          title: Text(a.$1),
                          subtitle: Text(a.$2),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Kpi extends StatelessWidget {
  final String label, value;
  final IconData icon;
  const _Kpi(this.label, this.value, this.icon);

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 20, color: AppColors.muted),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(color: AppColors.muted)),
          ],
        ),
      );
}

/// Oddiy 14 kunlik ustunli grafik (keyin fl_chart bilan almashtiramiz)
class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    final maxV = _last14.reduce((a, b) => a > b ? a : b);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Oxirgi 14 kun tushumi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
          const SizedBox(height: 16),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < _last14.length; i++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: Container(
                        height: 170 * _last14[i] / maxV,
                        decoration: BoxDecoration(
                          color: i == _last14.length - 1 ? AppColors.lime : AppColors.ink,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
