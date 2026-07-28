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

  /// Who the signed-in user is, and the way out of the account.
  static const String profile = '/profile';

  /// An object's own screen. The id is a path parameter rather than a query, so
  /// a link to an object reads as one thing and not as a screen plus an
  /// argument.
  static const String unit = '/unit/:unitId';

  /// Editing an object, and adding one inside it.
  ///
  /// Both hang off the object rather than sitting beside it as `/unit/new`,
  /// which would be matched by `:unitId` and turn "new" into an id.
  static const String unitEdit = '/unit/:unitId/edit';
  static const String unitAdd = '/unit/:unitId/add';

  static String unitPath(String unitId) => '/unit/$unitId';
  static String unitEditPath(String unitId) => '/unit/$unitId/edit';
  static String unitAddPath(String unitId) => '/unit/$unitId/add';
}
