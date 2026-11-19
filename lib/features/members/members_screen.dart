import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/widgets.dart';

const mockMembers = [
  ('Nodira Ergasheva', '+998 90 123 45 67', '12 oylik', '30.06.2027', 0, 'Faol'),
  ('Jasur Toshpulatov', '+998 91 234 56 78', '3 oylik', '21.11.2026', 0, 'Tugayapti'),
  ('Madina Rahimova', '+998 93 345 67 89', '1 oylik', '17.12.2026', 100000, 'Faol'),
  ('Sardor Aliyev', '+998 94 456 78 90', '6 oylik', '02.03.2027', 0, 'Faol'),
  ('Bobur Yusupov', '+998 97 567 89 01', '1 oylik', '10.11.2026', 0, 'Tugagan'),
  ('Malika Sodiqova', '+998 99 678 90 12', '3 oylik', '15.02.2027', 150000, 'Faol'),
  ('Aziz Karimov', '+998 90 789 01 23', '1 oylik', '21.11.2026', 0, 'Tugayapti'),
  ('Dilnoza Omonova', '+998 88 890 12 34', '12 oylik', '01.09.2027', 0, 'Faol'),
];

class MembersScreen extends StatefulWidget {
  const MembersScreen({super.key});
  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  String q = '';
  String status = 'Hammasi';

  @override
  Widget build(BuildContext context) {
    final list = [
      for (var i = 0; i < mockMembers.length; i++)
        if ((status == 'Hammasi' ||
                (status == 'Qarzdorlar' ? mockMembers[i].$5 > 0 : mockMembers[i].$6 == status)) &&
            (q.isEmpty ||
                mockMembers[i].$1.toLowerCase().contains(q.toLowerCase()) ||
                mockMembers[i].$2.contains(q)))
          i
    ];
    return PageBody(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        PageHeader('A\'zolar',
            subtitle: '${mockMembers.length} ta a\'zo',
            actions: [LimeButton('Yangi a\'zo', onPressed: () => _newMember(context))]),
        Row(children: [
          SizedBox(
            width: 320,
            child: TextField(
              onChanged: (v) => setState(() => q = v),
              decoration: const InputDecoration(
                hintText: 'Ism yoki telefon bo\'yicha qidirish',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ChipsRow(
            items: const ['Hammasi', 'Faol', 'Tugayapti', 'Tugagan', 'Qarzdorlar'],
            selected: status,
            onChanged: (v) => setState(() => status = v),
          ),
        ]),
        const SizedBox(height: 16),
        DataGrid(
          headers: const ['A\'zo', 'Telefon', 'Tarif', 'Tugash', 'Qarz', 'Holat'],
          flex: const [3, 3, 2, 2, 2, 2],
          onTap: (r) => context.go('/members/${list[r]}'),
          rows: [
            for (final i in list)
              [
                t(mockMembers[i].$1, bold: true),
                t(mockMembers[i].$2),
                t(mockMembers[i].$3),
                t(mockMembers[i].$4),
                t(mockMembers[i].$5 == 0 ? '—' : fmt(mockMembers[i].$5)),
                statusPill(mockMembers[i].$6),
              ],
          ],
        ),
      ]),
    );
  }

  /// D-07
  void _newMember(BuildContext context) => showAppDialog(
        context,
        title: 'Yangi a\'zo',
        confirm: 'Saqlash',
        body: Column(children: [
          field('Ism'),
          field('Familiya'),
          field('Telefon (+998...)'),
          const Text('Mobil ilovaga kirish shu raqam bilan bo\'ladi.',
              style: TextStyle(fontSize: 12, color: Colors.black54)),
        ]),
      );
}
