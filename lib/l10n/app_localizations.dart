import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_uk.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('uk')];

  /// Application name
  ///
  /// In uk, this message translates to:
  /// **'Двір'**
  String get appTitle;

  /// Placeholder text on the temporary home screen
  ///
  /// In uk, this message translates to:
  /// **'Основа готова — функції незабаром'**
  String get homePlaceholder;

  /// No description provided for @signIn.
  ///
  /// In uk, this message translates to:
  /// **'Увійти'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In uk, this message translates to:
  /// **'Зареєструватися'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In uk, this message translates to:
  /// **'Вийти'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In uk, this message translates to:
  /// **'Ел. пошта'**
  String get email;

  /// No description provided for @password.
  ///
  /// In uk, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердьте пароль'**
  String get confirmPassword;

  /// No description provided for @welcomeBack.
  ///
  /// In uk, this message translates to:
  /// **'З поверненням'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In uk, this message translates to:
  /// **'Створити акаунт'**
  String get createAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In uk, this message translates to:
  /// **'Немає акаунту? Зареєструйтесь'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In uk, this message translates to:
  /// **'Вже маєте акаунт? Увійдіть'**
  String get alreadyHaveAccount;

  /// No description provided for @emailRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть ел. пошту'**
  String get emailRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In uk, this message translates to:
  /// **'Введіть коректну ел. пошту'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть пароль'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In uk, this message translates to:
  /// **'Пароль має містити щонайменше 6 символів'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In uk, this message translates to:
  /// **'Паролі не збігаються'**
  String get passwordsDontMatch;

  /// No description provided for @confirmEmailTitle.
  ///
  /// In uk, this message translates to:
  /// **'Перевірте пошту'**
  String get confirmEmailTitle;

  /// Shown after sign-up when the account needs email confirmation
  ///
  /// In uk, this message translates to:
  /// **'Ми надіслали лист на {email}. Відкрийте посилання, щоб завершити реєстрацію.'**
  String confirmEmailBody(String email);

  /// No description provided for @backToSignIn.
  ///
  /// In uk, this message translates to:
  /// **'Повернутися до входу'**
  String get backToSignIn;

  /// No description provided for @errorNetwork.
  ///
  /// In uk, this message translates to:
  /// **'Немає з’єднання з інтернетом'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In uk, this message translates to:
  /// **'Помилка сервера. Спробуйте пізніше'**
  String get errorServer;

  /// No description provided for @errorNotFound.
  ///
  /// In uk, this message translates to:
  /// **'Не знайдено'**
  String get errorNotFound;

  /// No description provided for @errorUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Неочікувана помилка'**
  String get errorUnknown;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In uk, this message translates to:
  /// **'Невірна пошта або пароль'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In uk, this message translates to:
  /// **'Ця пошта вже зареєстрована'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorWeakPassword.
  ///
  /// In uk, this message translates to:
  /// **'Пароль надто простий'**
  String get errorWeakPassword;

  /// No description provided for @errorEmailNotConfirmed.
  ///
  /// In uk, this message translates to:
  /// **'Спочатку підтвердьте пошту'**
  String get errorEmailNotConfirmed;

  /// No description provided for @errorTooManyRequests.
  ///
  /// In uk, this message translates to:
  /// **'Забагато спроб. Спробуйте пізніше'**
  String get errorTooManyRequests;

  /// No description provided for @errorAuthUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося виконати дію'**
  String get errorAuthUnknown;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'uk':
      return AppLocalizationsUk();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
