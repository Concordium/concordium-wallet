import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/screens/onboarding/new/screen.dart';
import 'package:concordium_wallet/screens/onboarding/recover/screen.dart';
import 'package:concordium_wallet/screens/onboarding/start/screen.dart';
import 'package:go_router/go_router.dart';

/// The navigation router.
///
/// Must be stored in a global value to avoid resetting navigation on hot reload.
final appRouter = GoRouter(
  // TODO: Should maybe set initial location to "init" page that figures out whether to enter onboarding or not.
  initialLocation: '/onboarding/start',
  routes: [
    GoRoute(
      path: '/onboarding/start',
      builder: (context, state) => const OnboardingStartScreen(),
    ),
    GoRoute(
      path: '/onboarding/new',
      builder: (context, state) => const OnboardingNewWalletScreen(),
    ),
    GoRoute(
      path: '/onboarding/recover',
      builder: (context, state) => const OnboardingRecoverScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
