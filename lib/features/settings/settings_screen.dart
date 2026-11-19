import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../shared/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => PageBody(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PageHeader('Sozlamalar', subtitle: 'Tariflar, xodimlar, kirish QR\'i', actions: [
            GhostButton('Oy narxlari', onPressed: () => _prices(context)),
          ]),
          DataGrid(
            headers: const ['Tarif', 'Kunlar', 'Narx (noyabr)'],
            flex: const [3, 2, 3],
            rows: [
              [t('1 oylik', bold: true), t('30'), t('300 000')],
              [t('3 oylik', bold: true), t('90'), t('800 000')],
              [t('6 oylik', bold: true), t('180'), t('1 500 000')],
              [t('12 oylik', bold: true), t('365'), t('2 700 000')],
              [t('Bir martalik', bold: true), t('1'), t('30 000')],
            ],
          ),
          const SizedBox(height: 22),
          Row(children: [
            const Expanded(
              child: Text('Xodimlar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            LimeButton('Xodim taklif qilish', onPressed: () => _invite(context)),
          ]),
          const SizedBox(height: 12),
          DataGrid(
            headers: const ['Ism', 'Email', 'Rol', 'Filial'],
            flex: const [3, 4, 2, 2],
            rows: [
              [t('Dilshod B.', bold: true), t('dilshod@gympro.uz'), const Pill('Admin', AppColors.ink), t('Chilonzor')],
              [t('Sherzod Q.', bold: true), t('sherzod@gympro.uz'), const Pill('Egasi', AppColors.ok), t('Hammasi')],
              [t('Nilufar T.', bold: true), t('nilufar@gympro.uz'), const Pill('Qabulxona', AppColors.warn), t('Chilonzor')],
              [t('Azamat R.', bold: true), t('azamat@gympro.uz'), const Pill('Trener', AppColors.muted), t('Yunusobod')],
            ],
          ),
          const SizedBox(height: 22),
          AppCard(
            child: Row(children: [
              const Icon(Icons.qr_code_2, size: 34),
              const SizedBox(width: 14),
              const Expanded(
                child: Text('Kirish QR\'i: har 30 soniyada yangilanadi, masofa 150 m.'),
              ),
              GhostButton('Kirish ekranini ochish', onPressed: () => context.go('/entrance')),
            ]),
          ),
        ]),
      );

  /// D-25
  void _prices(BuildContext context) => showAppDialog(context,
      title: 'Dekabr 2026 narxlari',
      body: Column(children: [
        field('1 oylik', initial: '300000'),
        field('3 oylik', initial: '800000'),
        field('6 oylik', initial: '1500000'),
        field('12 oylik', initial: '2700000'),
        field('Bir martalik', initial: '30000'),
      ]));

  /// D-26
  void _invite(BuildContext context) => showAppDialog(context,
      title: 'Xodim taklif qilish',
      confirm: 'Taklif yuborish',
      body: Column(children: [field('Email'), field('Rol (admin, reception, trainer)')]));
}
