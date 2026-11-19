import 'package:go_router/go_router.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/gym_select_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/members/members_screen.dart';
import '../features/members/member_profile_screen.dart';
import '../features/sale/sale_screen.dart';
import '../features/visits/visits_screen.dart';
import '../features/visits/entrance_screen.dart';
import '../features/finance/finance_screen.dart';
import '../features/analytics/analytics_screen.dart';
import '../features/settings/settings_screen.dart';
import 'shell.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/gyms', builder: (_, __) => const GymSelectScreen()),
    GoRoute(path: '/entrance', builder: (_, __) => const EntranceScreen()),
    ShellRoute(
      builder: (_, __, child) => AdminShell(child: child),
      routes: [
        GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
        GoRoute(path: '/members', builder: (_, __) => const MembersScreen()),
        GoRoute(
          path: '/members/:id',
          builder: (_, s) => MemberProfileScreen(index: int.tryParse(s.pathParameters['id'] ?? '') ?? 0),
        ),
        GoRoute(path: '/sale', builder: (_, __) => const SaleScreen()),
        GoRoute(path: '/visits', builder: (_, __) => const VisitsScreen()),
        GoRoute(path: '/finance', builder: (_, __) => const FinanceScreen()),
        GoRoute(path: '/analytics', builder: (_, __) => const AnalyticsScreen()),
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      ],
    ),
  ],
);
