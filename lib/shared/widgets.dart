import 'package:flutter/material.dart';
import '../app/theme.dart';

String fmt(num n) {
  final s = n.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return (n < 0 ? '-' : '') + b.toString();
}

String two(int n) => n.toString().padLeft(2, '0');
String fmtDate(DateTime d) => '${two(d.day)}.${two(d.month)}.${d.year}';
String fmtTime(DateTime d) => '${two(d.hour)}:${two(d.minute)}';

String fmtDuration(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes % 60;
  final s = d.inSeconds % 60;
  return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
}

void toast(BuildContext context, String msg) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

class AppCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets padding;
  const AppCard({super.key, required this.child, this.color, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(
          color: color ?? Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.line),
        ),
        child: child,
      );
}

class LimeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const LimeButton(this.label, {super.key, this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lime,
            foregroundColor: AppColors.ink,
            disabledBackgroundColor: AppColors.line,
          ),
          onPressed: onPressed,
          icon: Icon(icon ?? Icons.arrow_forward, size: 20),
          label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        ),
      );
}

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool danger;
  const GhostButton(this.label, {super.key, this.onPressed, this.danger = false});

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: danger ? AppColors.danger : AppColors.ink,
            backgroundColor: Colors.white,
            side: const BorderSide(color: AppColors.line),
          ),
          onPressed: onPressed,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
        ),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  const Pill(this.text, this.color, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(20)),
        child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
      );
}

class Empty extends StatelessWidget {
  final String text;
  const Empty(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted)),
        ),
      );
}

Widget screenTitle(String t) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Text(t, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
    );

Widget sheetHandle() => Center(
      child: Container(
        width: 40,
        height: 4,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(color: AppColors.line, borderRadius: BorderRadius.circular(4)),
      ),
    );
