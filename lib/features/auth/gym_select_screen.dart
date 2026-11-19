import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';

class GymSelectScreen extends StatelessWidget {
  const GymSelectScreen({super.key});

  static const _gyms = [
    ('Chilonzor', 'Chilonzor 9-kvartal', '324 a\'zo'),
    ('Yunusobod', 'Yunusobod 4-mavze', '211 a\'zo'),
    ('Mirobod', 'Mirobod ko\'chasi 12', '158 a\'zo'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Qaysi filialda ishlaysiz?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 28),
            Wrap(
              spacing: 16,
              children: [
                for (final g in _gyms)
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => context.go('/dashboard'),
                    child: SizedBox(
                      width: 220,
                      child: AppCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(g.$1, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            const SizedBox(height: 4),
                            Text(g.$2, style: const TextStyle(color: AppColors.muted)),
                            const SizedBox(height: 14),
                            Text(g.$3, style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
