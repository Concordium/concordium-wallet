import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/screens/start/screen.dart';
import 'package:go_router/go_router.dart';

/// The navigation router.
///
/// Must be stored in a global value to avoid resetting navigation on hot reload.
final appRouter = GoRouter(
  // TODO: Should maybe set initial location to "init" page that figures out whether to enter onboarding or not.
  initialLocation: '/start',
  routes: [
    GoRoute(
      path: '/start',
      builder: (context, state) => const StartScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
