import 'package:concordium_wallet/screens/home/screen.dart';
import 'package:concordium_wallet/screens/onboarding/new/screen.dart';
import 'package:concordium_wallet/screens/onboarding/recover/screen.dart';
import 'package:concordium_wallet/screens/onboarding/start/screen.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: '/onboarding/start',
  routes: [
    GoRoute(
      path: '/onboarding/start',
      builder: (context, state) => const OnboardingStartScreen(),
    ),
    GoRoute(
      path: '/onboarding/new',
      builder: (context, state) => const OnboardingNewScreen(),
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
