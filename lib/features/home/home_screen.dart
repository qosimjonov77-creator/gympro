import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';
import '../payments/payments_screen.dart';

/// M-06
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _statusColor(SubStatus s) => switch (s) {
        SubStatus.active => AppColors.ok,
        SubStatus.expiring => AppColors.warn,
        SubStatus.expired => AppColors.danger,
        _ => Colors.white70,
      };

  @override
  Widget build(BuildContext context) => ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          final now = DateTime.now();
          final st = store.status;
          final hasSub = store.subEnd != null;
          final open = store.openVisit;
          final unread = store.reminders.length;

          return ListView(padding: const EdgeInsets.all(20), children: [
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Salom,', style: TextStyle(color: AppColors.muted)),
                  Text(store.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                ]),
              ),
              IconButton(
                onPressed: () => context.push('/notifications'),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  label: Text('$unread'),
                  child: const Icon(Icons.notifications_outlined, size: 28),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            AppCard(
              color: AppColors.ink,
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: Stack(alignment: Alignment.center, children: [
                    SizedBox(
                      width: 110,
                      height: 110,
                      child: CircularProgressIndicator(
                        value: hasSub ? (store.daysLeft / store.totalDays).clamp(0.0, 1.0) : 0,
                        strokeWidth: 10,
                        backgroundColor: Colors.white24,
                        color: AppColors.lime,
                      ),
                    ),
                    Column(mainAxisSize: MainAxisSize.min, children: [
                      Text('${store.daysLeft}',
                          style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                      const Text('kun qoldi', style: TextStyle(color: Colors.white60, fontSize: 12)),
                    ]),
                  ]),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Pill(store.statusLabel, _statusColor(st)),
                    const SizedBox(height: 10),
                    Text(store.subPlan ?? 'Obuna yo\'q',
                        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(hasSub ? '${fmtDate(store.subStart!)} — ${fmtDate(store.subEnd!)}' : 'Uzaytirish so\'rovini yuboring',
                        style: const TextStyle(color: Colors.white60, fontSize: 13)),
                  ]),
                ),
              ]),
            ),
            const SizedBox(height: 14),
            if (open != null)
              _InsideBanner(open)
            else
              LimeButton('QR\'ni skaner qilish', icon: Icons.qr_code_scanner, onPressed: () => context.push('/scan')),
            if (store.debt > 0) ...[
              const SizedBox(height: 14),
              AppCard(
                child: Row(children: [
                  const Icon(Icons.warning_amber_rounded, color: AppColors.danger),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Qarzingiz bor', style: TextStyle(fontWeight: FontWeight.w700)),
                      Text('${fmt(store.debt)} so\'m — qabulxonada to\'lang',
                          style: const TextStyle(color: AppColors.muted)),
                    ]),
                  ),
                ]),
              ),
            ],
            if (st == SubStatus.none || st == SubStatus.expired || st == SubStatus.expiring) ...[
              const SizedBox(height: 14),
              GhostButton('Uzaytirish so\'rovi', onPressed: () => showExtendSheet(context)),
            ],
            const SizedBox(height: 18),
            Row(children: [
              Expanded(child: _Stat('Shu oy tashrif', '${store.visitsInMonth(now.year, now.month).length}')),
              const SizedBox(width: 12),
              Expanded(child: _Stat('O\'rtacha vaqt', '${store.avgMinutes(now.year, now.month)} daq')),
            ]),
          ]);
        },
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

class _InsideBanner extends StatefulWidget {
  final Visit v;
  const _InsideBanner(this.v);
  @override
  State<_InsideBanner> createState() => _InsideBannerState();
}

class _InsideBannerState extends State<_InsideBanner> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () => context.push('/inside'),
        borderRadius: BorderRadius.circular(16),
        child: AppCard(
          color: AppColors.lime,
          child: Row(children: [
            const Icon(Icons.timer_outlined),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Zaldasiz · ${fmtDuration(DateTime.now().difference(widget.v.inAt))}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            ),
            const Icon(Icons.chevron_right),
          ]),
        ),
      );
}
