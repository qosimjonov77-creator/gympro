import 'package:flutter/foundation.dart';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

class Plan {
  final String name;
  final int days, price;
  const Plan(this.name, this.days, this.price);
}

class Visit {
  final String id;
  final DateTime inAt;
  DateTime? outAt;
  final bool ok;
  final String? reason;
  final String method; // phone_qr
  int? rating;
  Visit(this.id, this.inAt, this.ok, this.reason, this.method, {this.outAt, this.rating});
}

class Pay {
  final int receipt;
  final int amount;
  final String method, note;
  final DateTime at;
  Pay(this.receipt, this.amount, this.method, this.note, this.at);
}

class ExtendRequest {
  final String planName;
  final int price;
  final DateTime createdAt;
  String status; // new | done | rejected
  ExtendRequest(this.planName, this.price, this.createdAt, {this.status = 'new'});
}

class Announcement {
  final String title, body;
  final DateTime at;
  const Announcement(this.title, this.body, this.at);
}

class ScanResult {
  final bool ok;
  final String reason;
  final bool canExtend;
  const ScanResult(this.ok, this.reason, {this.canExtend = false});
}

enum SubStatus { none, active, expiring, expired, future }

/// Vaqtincha xotiradagi ombor. Firebase ulanganda repository bilan almashtiriladi.
class MemberStore extends ChangeNotifier {
  // sessiya
  bool onboarded = false;
  bool loggedIn = false;
  String phone = '';
  String name = '';

  // obuna
  String? subPlan;
  DateTime? subStart, subEnd;
  int subPrice = 0, subPaid = 0;
  int warnDays = 3;

  final visits = <Visit>[];
  final payments = <Pay>[];
  final requests = <ExtendRequest>[];
  final plans = const [
    Plan('1 oylik', 30, 300000),
    Plan('3 oylik', 90, 800000),
    Plan('6 oylik', 180, 1500000),
    Plan('12 oylik', 365, 2700000),
  ];
  final announcements = <Announcement>[
    Announcement('Xush kelibsiz!', 'GymPro a\'zolar ilovasiga xush kelibsiz. QR orqali zalga kiring.',
        DateTime.now().subtract(const Duration(days: 1))),
  ];
  ScanResult? lastScan;
  int _receipt = 1;
  int _seq = 0;

  // ---------- sessiya ----------
  void finishOnboarding() {
    onboarded = true;
    notifyListeners();
  }

  void login(String phone, String name) {
    this.phone = phone;
    this.name = name.trim().isEmpty ? 'A\'zo' : name.trim();
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    phone = '';
    name = '';
    subPlan = null;
    subStart = null;
    subEnd = null;
    subPrice = 0;
    subPaid = 0;
    visits.clear();
    payments.clear();
    requests.clear();
    lastScan = null;
    notifyListeners();
  }

  // ---------- obuna holati ----------
  SubStatus get status {
    if (subEnd == null || subStart == null) return SubStatus.none;
    final today = dateOnly(DateTime.now());
    if (subStart!.isAfter(today)) return SubStatus.future;
    if (subEnd!.isBefore(today)) return SubStatus.expired;
    return daysLeft <= warnDays ? SubStatus.expiring : SubStatus.active;
  }

  String get statusLabel => switch (status) {
        SubStatus.none => 'Obuna yo\'q',
        SubStatus.active => 'Faol',
        SubStatus.expiring => 'Tugayapti',
        SubStatus.expired => 'Tugagan',
        SubStatus.future => 'Kelajakda',
      };

  /// Tugash kuni ham kiradi
  int get daysLeft {
    if (subEnd == null) return 0;
    final d = subEnd!.difference(dateOnly(DateTime.now())).inDays + 1;
    return d < 0 ? 0 : d;
  }

  int get totalDays => (subStart == null || subEnd == null) ? 1 : subEnd!.difference(subStart!).inDays + 1;
  int get debt => (subPrice - subPaid) < 0 ? 0 : subPrice - subPaid;
  bool get canEnter => status == SubStatus.active || status == SubStatus.expiring;

  // ---------- skaner ----------
  Visit? get openVisit {
    for (final v in visits) {
      if (v.ok && v.outAt == null) return v;
    }
    return null;
  }

  ScanResult _deny(String reason, {bool canExtend = false}) {
    visits.add(Visit('v${_seq++}', DateTime.now(), false, reason, 'phone_qr'));
    lastScan = ScanResult(false, reason, canExtend: canExtend);
    notifyListeners();
    return lastScan!;
  }

  /// QR ichida: gympro://in?g={gym}&t={token}
  ScanResult scan(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != 'gympro' || uri.host != 'in' || (uri.queryParameters['t'] ?? '').isEmpty) {
      return _deny('QR noto\'g\'ri. Zal eshigidagi QR\'ni skaner qiling');
    }
    if (openVisit != null) return _deny('Siz allaqachon kirgansiz');
    if (!canEnter) {
      return _deny(status == SubStatus.none ? 'Obunangiz yo\'q' : 'Obuna muddati tugagan', canExtend: true);
    }
    visits.add(Visit('v${_seq++}', DateTime.now(), true, null, 'phone_qr'));
    lastScan = const ScanResult(true, '');
    notifyListeners();
    return lastScan!;
  }

  void checkOut(int? rating) {
    final v = openVisit;
    if (v == null) return;
    v.outAt = DateTime.now();
    v.rating = rating;
    notifyListeners();
  }

  // ---------- tashriflar statistikasi ----------
  List<Visit> visitsInMonth(int y, int m) =>
      visits.where((v) => v.ok && v.inAt.year == y && v.inAt.month == m).toList();

  int avgMinutes(int y, int m) {
    final done = visitsInMonth(y, m).where((v) => v.outAt != null).toList();
    if (done.isEmpty) return 0;
    final total = done.fold<int>(0, (a, v) => a + v.outAt!.difference(v.inAt).inMinutes);
    return (total / done.length).round();
  }

  // ---------- uzaytirish so'rovi ----------
  void requestExtend(Plan p) {
    requests.add(ExtendRequest(p.name, p.price, DateTime.now()));
    notifyListeners();
  }

  // ---------- eslatmalar ----------
  List<(String, String, bool)> get reminders {
    final r = <(String, String, bool)>[];
    if (status == SubStatus.expiring) {
      r.add(('Obuna tez orada tugaydi', '$daysLeft kun qoldi (${subEnd == null ? '' : _d(subEnd!)})', true));
    } else if (status == SubStatus.expired) {
      r.add(('Obuna tugagan', 'Uzaytirish uchun so\'rov yuboring', true));
    }
    if (debt > 0) r.add(('Qarzingiz bor', '${debt.toString()} so\'m', true));
    return r;
  }

  String _d(DateTime d) => '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  void setWarnDays(int d) {
    warnDays = d;
    notifyListeners();
  }

  // ---------- DEMO (Firebase ulanguncha qabulxona o'rnida) ----------
  void demoSell(Plan p) {
    final start = dateOnly(DateTime.now());
    subPlan = p.name;
    subStart = start;
    subEnd = start.add(Duration(days: p.days - 1));
    subPrice = p.price;
    subPaid = p.price;
    payments.add(Pay(_receipt++, p.price, 'Naqd', p.name, DateTime.now()));
    notifyListeners();
  }

  void demoExpire() {
    if (subEnd == null) return;
    final y = dateOnly(DateTime.now()).subtract(const Duration(days: 1));
    subEnd = y;
    if (subStart != null && subStart!.isAfter(y)) subStart = y;
    notifyListeners();
  }

  void demoExpireSoon() {
    if (subEnd == null) return;
    subEnd = dateOnly(DateTime.now()).add(const Duration(days: 2));
    notifyListeners();
  }

  void demoDebt() {
    if (subPlan == null) return;
    subPaid = (subPrice / 2).round();
    notifyListeners();
  }
}

final store = MemberStore();
