import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../data/store.dart';
import '../../shared/widgets.dart';

/// M-17
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Xabarlar', style: TextStyle(fontWeight: FontWeight.w800)),
          leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
        ),
        body: ListenableBuilder(
          listenable: store,
          builder: (context, _) {
            final rem = store.reminders;
            return ListView(padding: const EdgeInsets.all(20), children: [
              if (rem.isEmpty && store.announcements.isEmpty) const Empty('Xabarlar yo\'q'),
              for (final r in rem)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    child: Row(children: [
                      const Icon(Icons.notifications_active, color: AppColors.warn),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(r.$1, style: const TextStyle(fontWeight: FontWeight.w700)),
                          Text(r.$2, style: const TextStyle(color: AppColors.muted)),
                        ]),
                      ),
                    ]),
                  ),
                ),
              for (final a in store.announcements)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AppCard(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        const Icon(Icons.campaign_outlined),
                        const SizedBox(width: 10),
                        Expanded(child: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700))),
                        Text(fmtDate(a.at), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
                      ]),
                      const SizedBox(height: 6),
                      Text(a.body, style: const TextStyle(color: AppColors.muted)),
                    ]),
                  ),
                ),
            ]);
          },
        ),
      );
}
