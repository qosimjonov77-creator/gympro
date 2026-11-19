import 'package:flutter/material.dart';

class AppColors {
  static const lime = Color(0xFFC6F432);
  static const ink = Color(0xFF0E0F0C);
  static const bg = Color(0xFFF4F4EE);
  static const line = Color(0xFFE5E5DC);
  static const muted = Color(0xFF6B6B63);
  static const danger = Color(0xFFD92D20);
  static const warn = Color(0xFFF79009);
  static const ok = Color(0xFF12B76A);
}

ThemeData buildTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: AppColors.lime).copyWith(
    primary: AppColors.ink,
    onPrimary: Colors.white,
    secondary: AppColors.lime,
    onSecondary: AppColors.ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.bg,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.line),
      ),
    ),
  );
}

/// Oq kartochka (hamma ekranda ishlatiladi)
class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  const AppCard({
    super.key,
    required this.child,
    this.color,
    this.padding = const EdgeInsets.all(18),
  });

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: child,
      );
}