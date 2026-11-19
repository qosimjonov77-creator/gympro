import 'package:flutter/material.dart';
import '../app/theme.dart';

/// 1250000 -> "1 250 000"
String fmt(num n) {
  final s = n.round().abs().toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write(' ');
    b.write(s[i]);
  }
  return (n < 0 ? '-' : '') + b.toString();
}

String fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

Text t(String s, {bool bold = false, Color? color, double? size}) => Text(
      s,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        color: color,
        fontSize: size,
      ),
    );

class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> actions;
  const PageHeader(this.title, {super.key, this.subtitle, this.actions = const []});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
              if (subtitle != null)
                Text(subtitle!, style: const TextStyle(color: AppColors.muted)),
            ]),
          ),
          for (final a in actions) Padding(padding: const EdgeInsets.only(left: 10), child: a),
        ]),
      );
}

class PageBody extends StatelessWidget {
  final Widget child;
  const PageBody({super.key, required this.child});
  @override
  Widget build(BuildContext context) =>
      SingleChildScrollView(padding: const EdgeInsets.all(28), child: child);
}

class LimeButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  const LimeButton(this.label, {super.key, this.icon, this.onPressed});
  @override
  Widget build(BuildContext context) => FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.lime,
          foregroundColor: AppColors.ink,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        onPressed: onPressed,
        icon: Icon(icon ?? Icons.add, size: 18),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
      );
}

class GhostButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool danger;
  const GhostButton(this.label, {super.key, this.onPressed, this.danger = false});
  @override
  Widget build(BuildContext context) => OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: danger ? AppColors.danger : AppColors.ink,
          side: const BorderSide(color: AppColors.line),
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      );
}

class Pill extends StatelessWidget {
  final String text;
  final Color color;
  const Pill(this.text, this.color, {super.key});
  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withAlpha(30),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(text,
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ),
      );
}

Pill statusPill(String s) => Pill(
      s,
      switch (s) {
        'Faol' => AppColors.ok,
        'Tugayapti' => AppColors.warn,
        'Tugagan' || 'Rad etildi' => AppColors.danger,
        _ => AppColors.muted,
      },
    );

class DataGrid extends StatelessWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final List<int>? flex;
  final void Function(int index)? onTap;
  const DataGrid({super.key, required this.headers, required this.rows, this.flex, this.onTap});

  int _f(int i) => flex == null ? 1 : flex![i];

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.line)),
            ),
            child: Row(children: [
              for (var i = 0; i < headers.length; i++)
                Expanded(
                  flex: _f(i),
                  child: Text(headers[i],
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
            ]),
          ),
          for (var r = 0; r < rows.length; r++)
            InkWell(
              onTap: onTap == null ? null : () => onTap!(r),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                decoration: BoxDecoration(
                  border: r == rows.length - 1
                      ? null
                      : const Border(bottom: BorderSide(color: AppColors.line)),
                ),
                child: Row(children: [
                  for (var i = 0; i < rows[r].length; i++)
                    Expanded(flex: _f(i), child: rows[r][i]),
                ]),
              ),
            ),
        ]),
      );
}

Widget field(String label, {String? initial, bool obscure = false, TextEditingController? c}) =>
    Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        initialValue: c == null ? initial : null,
        obscureText: obscure,
        decoration: InputDecoration(labelText: label),
      ),
    );

Future<bool?> showAppDialog(
  BuildContext context, {
  required String title,
  required Widget body,
  String confirm = 'Saqlash',
  String cancel = 'Bekor qilish',
  bool danger = false,
  bool showCancel = true,
}) =>
    showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: Text(title),
        content: SizedBox(width: 420, child: SingleChildScrollView(child: body)),
        actions: [
          if (showCancel)
            TextButton(onPressed: () => Navigator.pop(c, false), child: Text(cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: danger ? AppColors.danger : AppColors.lime,
              foregroundColor: danger ? Colors.white : AppColors.ink,
            ),
            onPressed: () => Navigator.pop(c, true),
            child: Text(confirm),
          ),
        ],
      ),
    );

class Kpi extends StatelessWidget {
  final String label, value;
  final Color? valueColor;
  const Kpi(this.label, this.value, {super.key, this.valueColor});
  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: AppColors.muted)),
          const SizedBox(height: 8),
          Text(value,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: valueColor)),
        ]),
      );
}

/// Tanlanadigan chiplar qatori
class ChipsRow extends StatelessWidget {
  final List<String> items;
  final String selected;
  final ValueChanged<String> onChanged;
  const ChipsRow({super.key, required this.items, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (final i in items)
          ChoiceChip(
            label: Text(i),
            selected: i == selected,
            selectedColor: AppColors.lime,
            backgroundColor: Colors.white,
            onSelected: (_) => onChanged(i),
          ),
      ]);
}
