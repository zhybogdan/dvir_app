/// Centralized route paths so screens and the router never hardcode strings.
abstract final class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';

  /// Everything under this prefix is for a user who belongs nowhere yet. The
  /// redirect treats the whole subtree as one place, so its sub-paths stay
  /// navigable without bouncing back to the choice screen.
  static const String onboarding = '/onboarding';
  static const String onboardingCommunity = '/onboarding/community';
  static const String onboardingCommunitySuccess =
      '/onboarding/community/success';
  static const String onboardingUnit = '/onboarding/unit';
  static const String onboardingUnitSuccess = '/onboarding/unit/success';
  static const String onboardingJoin = '/onboarding/join';

  static const String pending = '/pending';

  /// An object's own screen. The id is a path parameter rather than a query, so
  /// a link to an object reads as one thing and not as a screen plus an
  /// argument.
  static const String unit = '/unit/:unitId';

  static String unitPath(String unitId) => '/unit/$unitId';
}
