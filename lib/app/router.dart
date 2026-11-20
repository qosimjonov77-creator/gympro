import 'package:go_router/go_router.dart';
import '../features/auth/auth_screens.dart';
import '../features/home/home_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/payments/payments_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/scan/scan_screens.dart';
import '../features/visits/visits_screen.dart';
import 'shell.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
    GoRoute(path: '/phone', builder: (context, state) => const PhoneScreen()),
    GoRoute(path: '/sms', builder: (context, state) => SmsScreen(phone: state.uri.queryParameters['p'] ?? '')),
    GoRoute(path: '/found', builder: (context, state) => FoundScreen(phone: state.uri.queryParameters['p'] ?? '')),
    GoRoute(path: '/scan', builder: (context, state) => const ScanScreen()),
    GoRoute(path: '/granted', builder: (context, state) => const GrantedScreen()),
    GoRoute(path: '/denied', builder: (context, state) => const DeniedScreen()),
    GoRoute(path: '/inside', builder: (context, state) => const InsideScreen()),
    GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
    ShellRoute(
      builder: (context, state, child) => MemberShell(child: child),
      routes: [
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(path: '/visits', builder: (context, state) => const VisitsScreen()),
        GoRoute(path: '/payments', builder: (context, state) => const PaymentsScreen()),
        GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      ],
    ),
  ],
);
