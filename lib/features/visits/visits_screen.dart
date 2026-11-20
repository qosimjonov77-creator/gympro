import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// M-13
class VisitsScreen extends StatefulWidget {
  const VisitsScreen({super.key});
  @override
  State<VisitsScreen> createState() => _VisitsScreenState();
}

class _VisitsScreenState extends State<VisitsScreen> {
  DateTime month = DateTime(DateTime.now().year, DateTime.now().month);

  static const _names = [
    '', 'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'Iyun',
    'Iyul', 'Avgust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr'
  ];

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final list = store.visitsInMonth(month.year, month.month)..sort((a, b) => b.inAt.compareTo(a.inAt));
          final days = list.map((v) => v.inAt.day).toSet();
          final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
          final lead = DateTime(month.year, month.month, 1).weekday - 1;

          return ListView(padding: const EdgeInsets.only(bottom: 24), children: [
            screenTitle('Tashriflar'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AppCard(
                child: Column(children: [
                  Row(children: [
                    IconButton(
                      onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text('${_names[month.month]} ${month.year}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                    IconButton(
                      onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ]),
                  Row(children: [
                    for (final d in const ['Du', 'Se', 'Ch', 'Pa', 'Ju', 'Sh', 'Ya'])
                      Expanded(
                        child: Center(child: Text(d, style: const TextStyle(color: AppColors.muted, fontSize: 12))),
                      ),
                  ]),
                  const SizedBox(height: 6),
                  GridView.count(
                    crossAxisCount: 7,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (var i = 0; i < lead; i++) const SizedBox(),
                      for (var d = 1; d <= daysInMonth; d++)
                        Container(
                          margin: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: days.contains(d) ? AppColors.lime : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text('$d',
                                style: TextStyle(
                                    fontWeight: days.contains(d) ? FontWeight.w800 : FontWeight.w400,
                                    color: AppColors.ink)),
                          ),
                        ),
                    ],
                  ),
                ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
              child: Row(children: [
                Expanded(child: _Stat('Tashrif', '${list.length}')),
                const SizedBox(width: 12),
                Expanded(child: _Stat('O\'rtacha', '${store.avgMinutes(month.year, month.month)} daq')),
              ]),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Text('Oxirgi tashriflar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            if (list.isEmpty)
              const Empty('Bu oyda tashrif yo\'q')
            else
              for (final v in list)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _detail(context, v),
                    child: AppCard(
                      child: Row(children: [
                        const Icon(Icons.login_rounded, color: AppColors.muted),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(fmtDate(v.inAt), style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('${fmtTime(v.inAt)} — ${v.outAt == null ? 'zalda' : fmtTime(v.outAt!)}',
                                style: const TextStyle(color: AppColors.muted)),
                          ]),
                        ),
                        if (v.outAt != null)
                          Text('${v.outAt!.difference(v.inAt).inMinutes} daq',
                              style: const TextStyle(fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ),
                ),
          ]);
        },
      );

  /// M-14
  void _detail(BuildContext context, Visit v) => showModalBottomSheet(
        context: context,
        builder: (c) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            sheetHandle(),
            const Text('Tashrif tafsiloti', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 14),
            _row('Sana', fmtDate(v.inAt)),
            _row('Kirish', fmtTime(v.inAt)),
            _row('Chiqish', v.outAt == null ? '—' : fmtTime(v.outAt!)),
            _row('Usul', v.method == 'phone_qr' ? 'Telefon QR' : 'Qo\'lda'),
            _row('Baho', v.rating == null ? '—' : '${v.rating} / 5'),
            _row('Tashrif ID', v.id),
            const SizedBox(height: 8),
          ]),
        ),
      );

  Widget _row(String a, String b) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(a, style: const TextStyle(color: AppColors.muted)),
          Text(b, style: const TextStyle(fontWeight: FontWeight.w700)),
        ]),
      );
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat(this.label, this.value);

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.muted, fontSize: 13)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        ]),
      );
}
