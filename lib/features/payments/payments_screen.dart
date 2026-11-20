import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// M-15
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) => ListView(padding: const EdgeInsets.only(bottom: 24), children: [
          screenTitle('To\'lovlar va tariflar'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AppCard(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Joriy obuna', style: TextStyle(color: AppColors.muted)),
                const SizedBox(height: 6),
                Text(store.subPlan ?? 'Obuna yo\'q', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                if (store.subEnd != null)
                  Text('${fmtDate(store.subStart!)} — ${fmtDate(store.subEnd!)} · ${store.statusLabel}',
                      style: const TextStyle(color: AppColors.muted)),
                if (store.debt > 0) ...[
                  const SizedBox(height: 10),
                  Text('Qarz: ${fmt(store.debt)} so\'m',
                      style: const TextStyle(color: AppColors.danger, fontWeight: FontWeight.w700)),
                ],
                const SizedBox(height: 14),
                LimeButton('Uzaytirish so\'rovi', icon: Icons.refresh, onPressed: () => showExtendSheet(context)),
              ]),
            ),
          ),
          _title('Tariflar'),
          for (final p in store.plans)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: AppCard(
                child: Row(children: [
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(p.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      Text('${p.days} kun', style: const TextStyle(color: AppColors.muted)),
                    ]),
                  ),
                  Text('${fmt(p.price)} so\'m', style: const TextStyle(fontWeight: FontWeight.w800)),
                ]),
              ),
            ),
          _title('So\'rovlar'),
          if (store.requests.isEmpty)
            const Empty('Uzaytirish so\'rovlari yo\'q')
          else
            for (final r in store.requests.reversed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: AppCard(
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(r.planName, style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text(fmtDate(r.createdAt), style: const TextStyle(color: AppColors.muted)),
                      ]),
                    ),
                    Pill(
                      switch (r.status) { 'done' => 'Bajarildi', 'rejected' => 'Rad etildi', _ => 'Yangi' },
                      switch (r.status) { 'done' => AppColors.ok, 'rejected' => AppColors.danger, _ => AppColors.warn },
                    ),
                  ]),
                ),
              ),
          _title('To\'lov tarixi'),
          if (store.payments.isEmpty)
            const Empty('Hali to\'lov yo\'q')
          else
            for (final p in store.payments.reversed)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: AppCard(
                  child: Row(children: [
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Chek №${p.receipt}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        Text('${fmtDate(p.at)} · ${p.method} · ${p.note}',
                            style: const TextStyle(color: AppColors.muted, fontSize: 13)),
                      ]),
                    ),
                    Text(fmt(p.amount), style: const TextStyle(fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
        ]),
      );

  Widget _title(String t) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
        child: Text(t, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
      );
}

/// M-16
Future<void> showExtendSheet(BuildContext context) {
  int sel = 0;
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (c) => StatefulBuilder(
      builder: (c, setS) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          sheetHandle(),
          const Text('Uzaytirish so\'rovi', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('So\'rov qabulxonaga boradi, to\'lovni zalda qilasiz.', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 14),
          for (var i = 0; i < store.plans.length; i++)
            InkWell(
              onTap: () => setS(() => sel = i),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: i == sel ? AppColors.lime : Colors.white,
                  border: Border.all(color: i == sel ? AppColors.ink : AppColors.line),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(children: [
                  Expanded(child: Text(store.plans[i].name, style: const TextStyle(fontWeight: FontWeight.w700))),
                  Text('${fmt(store.plans[i].price)} so\'m'),
                ]),
              ),
            ),
          const SizedBox(height: 8),
          LimeButton('So\'rov yuborish', icon: Icons.send, onPressed: () {
            store.requestExtend(store.plans[sel]);
            Navigator.pop(c);
            toast(context, 'So\'rov yuborildi');
          }),
        ]),
      ),
    ),
  );
}
