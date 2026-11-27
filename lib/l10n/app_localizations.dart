import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('uk'),
  ];

  /// Application name
  ///
  /// In uk, this message translates to:
  /// **'Двір'**
  String get appTitle;

  /// No description provided for @scopesTitle.
  ///
  /// In uk, this message translates to:
  /// **'Мої об’єкти'**
  String get scopesTitle;

  /// How many documents an object holds, on its card in the list
  ///
  /// In uk, this message translates to:
  /// **'{count, plural, one{{count} документ} few{{count} документи} many{{count} документів} other{{count} документа}}'**
  String scopePapers(int count);

  /// How many facts an object's record holds, on its card in the list
  ///
  /// In uk, this message translates to:
  /// **'{count, plural, one{{count} факт} few{{count} факти} many{{count} фактів} other{{count} факту}}'**
  String scopeFacts(int count);

  /// How many objects stand inside this one, on its card in the list
  ///
  /// In uk, this message translates to:
  /// **'{count} усередині'**
  String scopeInside(int count);

  /// No description provided for @scopesCommunities.
  ///
  /// In uk, this message translates to:
  /// **'Спільноти'**
  String get scopesCommunities;

  /// No description provided for @scopesUnits.
  ///
  /// In uk, this message translates to:
  /// **'Оселі'**
  String get scopesUnits;

  /// No description provided for @scopePending.
  ///
  /// In uk, this message translates to:
  /// **'Очікує підтвердження'**
  String get scopePending;

  /// No description provided for @addScope.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get addScope;

  /// The lead on the list of objects before the first one exists
  ///
  /// In uk, this message translates to:
  /// **'Почніть з того, що вам належить: дім, квартира, гараж чи ділянка.'**
  String get scopesEmptyLead;

  /// No description provided for @scopesEmptyCreate.
  ///
  /// In uk, this message translates to:
  /// **'Створіть перший об’єкт'**
  String get scopesEmptyCreate;

  /// No description provided for @scopesEmptyCreateWhy.
  ///
  /// In uk, this message translates to:
  /// **'Далі до нього лягають документи, факти й телефони'**
  String get scopesEmptyCreateWhy;

  /// Second first move on an empty app: the records may already exist on an old phone
  ///
  /// In uk, this message translates to:
  /// **'Відновіть з копії'**
  String get scopesEmptyRestore;

  /// No description provided for @scopesEmptyRestoreWhy.
  ///
  /// In uk, this message translates to:
  /// **'Якщо на старому телефоні вже все записано'**
  String get scopesEmptyRestoreWhy;

  /// No description provided for @memberStatusPending.
  ///
  /// In uk, this message translates to:
  /// **'Очікує підтвердження'**
  String get memberStatusPending;

  /// No description provided for @memberStatusActive.
  ///
  /// In uk, this message translates to:
  /// **'Активний'**
  String get memberStatusActive;

  /// No description provided for @memberStatusRejected.
  ///
  /// In uk, this message translates to:
  /// **'Відхилено'**
  String get memberStatusRejected;

  /// No description provided for @memberStatusBlocked.
  ///
  /// In uk, this message translates to:
  /// **'Доступ закрито'**
  String get memberStatusBlocked;

  /// No description provided for @profileTitle.
  ///
  /// In uk, this message translates to:
  /// **'Профіль'**
  String get profileTitle;

  /// No description provided for @navObjects.
  ///
  /// In uk, this message translates to:
  /// **'Об’єкти'**
  String get navObjects;

  /// No description provided for @profileHint.
  ///
  /// In uk, this message translates to:
  /// **'Ім’я побачать люди у ваших оселях — без нього ви для них просто «Мешканець».'**
  String get profileHint;

  /// No description provided for @profileName.
  ///
  /// In uk, this message translates to:
  /// **'Ім’я'**
  String get profileName;

  /// No description provided for @profileNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Марія Левченко'**
  String get profileNameHint;

  /// No description provided for @profileNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть ім’я'**
  String get profileNameRequired;

  /// No description provided for @profilePhone.
  ///
  /// In uk, this message translates to:
  /// **'Телефон'**
  String get profilePhone;

  /// No description provided for @profilePhoneHint.
  ///
  /// In uk, this message translates to:
  /// **'+380 67 123 45 67'**
  String get profilePhoneHint;

  /// No description provided for @profilePhoneInvalid.
  ///
  /// In uk, this message translates to:
  /// **'Схоже, це не номер'**
  String get profilePhoneInvalid;

  /// No description provided for @profileSaved.
  ///
  /// In uk, this message translates to:
  /// **'Збережено'**
  String get profileSaved;

  /// No description provided for @settingsTitle.
  ///
  /// In uk, this message translates to:
  /// **'Налаштування'**
  String get settingsTitle;

  /// Sits at the foot of the settings screen; the build number is included so a bug report can name it
  ///
  /// In uk, this message translates to:
  /// **'Версія {version}'**
  String aboutVersion(String version);

  /// No description provided for @settingsStoredHere.
  ///
  /// In uk, this message translates to:
  /// **'Усе лежить на цьому телефоні'**
  String get settingsStoredHere;

  /// No description provided for @settingsTheme.
  ///
  /// In uk, this message translates to:
  /// **'Тема'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In uk, this message translates to:
  /// **'Світла'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In uk, this message translates to:
  /// **'Темна'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In uk, this message translates to:
  /// **'Системна'**
  String get settingsThemeSystem;

  /// No description provided for @settingsLanguage.
  ///
  /// In uk, this message translates to:
  /// **'Мова'**
  String get settingsLanguage;

  /// A language names itself: this value is the same in every .arb
  ///
  /// In uk, this message translates to:
  /// **'Українська'**
  String get settingsLanguageUk;

  /// A language names itself: this value is the same in every .arb
  ///
  /// In uk, this message translates to:
  /// **'English'**
  String get settingsLanguageEn;

  /// No description provided for @settingsUnitsCount.
  ///
  /// In uk, this message translates to:
  /// **'{count, plural, one{{count} об’єкт} few{{count} об’єкти} many{{count} об’єктів} other{{count} об’єкта}}'**
  String settingsUnitsCount(int count);

  /// No description provided for @settingsSizeKilobytes.
  ///
  /// In uk, this message translates to:
  /// **'{size} КБ'**
  String settingsSizeKilobytes(String size);

  /// No description provided for @settingsSizeMegabytes.
  ///
  /// In uk, this message translates to:
  /// **'{size} МБ'**
  String settingsSizeMegabytes(String size);

  /// No description provided for @backupCreate.
  ///
  /// In uk, this message translates to:
  /// **'Створити копію'**
  String get backupCreate;

  /// No description provided for @backupCreateHint.
  ///
  /// In uk, this message translates to:
  /// **'Усі записи, документи й контакти одним архівом. Збережіть його в хмарі або на комп’ютері — тоді втрачений телефон не забере їх разом із собою.'**
  String get backupCreateHint;

  /// No description provided for @backupLastNever.
  ///
  /// In uk, this message translates to:
  /// **'Копії ще не робили'**
  String get backupLastNever;

  /// No description provided for @backupLastToday.
  ///
  /// In uk, this message translates to:
  /// **'Остання копія: сьогодні'**
  String get backupLastToday;

  /// No description provided for @backupLastYesterday.
  ///
  /// In uk, this message translates to:
  /// **'Остання копія: вчора'**
  String get backupLastYesterday;

  /// How long ago this phone last shared a backup, in whole days (2 or more)
  ///
  /// In uk, this message translates to:
  /// **'Остання копія: {count, plural, one{{count} день} few{{count} дні} many{{count} днів} other{{count} дня}} тому'**
  String backupLastDaysAgo(int count);

  /// No description provided for @backupRestore.
  ///
  /// In uk, this message translates to:
  /// **'Відновити з копії'**
  String get backupRestore;

  /// No description provided for @backupRestoreHint.
  ///
  /// In uk, this message translates to:
  /// **'Візьме архів і замінить ним усе, що зараз у застосунку.'**
  String get backupRestoreHint;

  /// No description provided for @backupRestoreConfirmTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відновити з копії?'**
  String get backupRestoreConfirmTitle;

  /// Shown before a restore replaces everything. The counts come from the archive's own manifest, so the person can tell one copy from another; named with a colon rather than counted in words because Ukrainian would need a plural form for each number
  ///
  /// In uk, this message translates to:
  /// **'Копія від {date}.\nОб’єкти: {units}\nДокументи: {documents}\nКонтакти: {contacts}\n\nУсе, що зараз у застосунку, буде замінено тим, що в копії.'**
  String backupRestoreConfirmBody(
    String date,
    int units,
    int documents,
    int contacts,
  );

  /// No description provided for @backupRestoreConfirmCta.
  ///
  /// In uk, this message translates to:
  /// **'Відновити'**
  String get backupRestoreConfirmCta;

  /// No description provided for @backupRestored.
  ///
  /// In uk, this message translates to:
  /// **'Відновлено з копії'**
  String get backupRestored;

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
  /// **'Перевірте адресу'**
  String get invalidEmail;

  /// No description provided for @passwordRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть пароль'**
  String get passwordRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In uk, this message translates to:
  /// **'Щонайменше 6 символів'**
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

  /// No description provided for @onboardingTitle.
  ///
  /// In uk, this message translates to:
  /// **'З чого почнемо?'**
  String get onboardingTitle;

  /// No description provided for @onboardingCreateCommunity.
  ///
  /// In uk, this message translates to:
  /// **'Створити спільноту'**
  String get onboardingCreateCommunity;

  /// No description provided for @onboardingCreateUnit.
  ///
  /// In uk, this message translates to:
  /// **'Створити оселю'**
  String get onboardingCreateUnit;

  /// No description provided for @onboardingJoinByCode.
  ///
  /// In uk, this message translates to:
  /// **'Приєднатися за кодом'**
  String get onboardingJoinByCode;

  /// No description provided for @pendingApprovalTitle.
  ///
  /// In uk, this message translates to:
  /// **'Заявку надіслано'**
  String get pendingApprovalTitle;

  /// No description provided for @pendingApprovalBody.
  ///
  /// In uk, this message translates to:
  /// **'Очікуйте підтвердження. Ми відкриємо доступ, щойно заявку розглянуть.'**
  String get pendingApprovalBody;

  /// No description provided for @rejectedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Заявку відхилено'**
  String get rejectedTitle;

  /// No description provided for @rejectedBody.
  ///
  /// In uk, this message translates to:
  /// **'Ваш запит на приєднання відхилили. Спробуйте попросити код ще раз у того, хто вас запрошував.'**
  String get rejectedBody;

  /// No description provided for @blockedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Доступ закрито'**
  String get blockedTitle;

  /// No description provided for @blockedBody.
  ///
  /// In uk, this message translates to:
  /// **'Господар оселі закрив вам доступ.'**
  String get blockedBody;

  /// No description provided for @refreshCta.
  ///
  /// In uk, this message translates to:
  /// **'Оновити'**
  String get refreshCta;

  /// No description provided for @withdraw.
  ///
  /// In uk, this message translates to:
  /// **'Відкликати'**
  String get withdraw;

  /// No description provided for @withdrawRequest.
  ///
  /// In uk, this message translates to:
  /// **'Відкликати заявку'**
  String get withdrawRequest;

  /// No description provided for @withdrawRequestTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відкликати заявку?'**
  String get withdrawRequestTitle;

  /// No description provided for @withdrawRequestBody.
  ///
  /// In uk, this message translates to:
  /// **'Ви зможете подати її знову за тим самим кодом.'**
  String get withdrawRequestBody;

  /// No description provided for @pendingOtherWays.
  ///
  /// In uk, this message translates to:
  /// **'Створити свою оселю або ввести інший код'**
  String get pendingOtherWays;

  /// No description provided for @joinByCodeIntro.
  ///
  /// In uk, this message translates to:
  /// **'Введіть код запрошення, який вам надіслали, щоб приєднатися до спільноти або оселі.'**
  String get joinByCodeIntro;

  /// No description provided for @joinCodeHint.
  ///
  /// In uk, this message translates to:
  /// **'A3F9C1B2'**
  String get joinCodeHint;

  /// No description provided for @joinCodeRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть код запрошення'**
  String get joinCodeRequired;

  /// No description provided for @joinCta.
  ///
  /// In uk, this message translates to:
  /// **'Приєднатися'**
  String get joinCta;

  /// No description provided for @communityName.
  ///
  /// In uk, this message translates to:
  /// **'Назва спільноти'**
  String get communityName;

  /// No description provided for @communityNameHint.
  ///
  /// In uk, this message translates to:
  /// **'ОСББ «Каштан»'**
  String get communityNameHint;

  /// No description provided for @communityNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть назву спільноти'**
  String get communityNameRequired;

  /// No description provided for @communityType.
  ///
  /// In uk, this message translates to:
  /// **'Тип спільноти'**
  String get communityType;

  /// No description provided for @communityAddress.
  ///
  /// In uk, this message translates to:
  /// **'Адреса'**
  String get communityAddress;

  /// No description provided for @communityAddressHint.
  ///
  /// In uk, this message translates to:
  /// **'вул. Хрещатик, 1'**
  String get communityAddressHint;

  /// No description provided for @communityCity.
  ///
  /// In uk, this message translates to:
  /// **'Місто'**
  String get communityCity;

  /// No description provided for @communityCityHint.
  ///
  /// In uk, this message translates to:
  /// **'Київ'**
  String get communityCityHint;

  /// No description provided for @optional.
  ///
  /// In uk, this message translates to:
  /// **'необов’язково'**
  String get optional;

  /// Shown when a field holds more than its column can store; the field's own cap stops ordinary typing, so this answers the cases it cannot — a paste, or emoji, which the keyboard and the database count differently
  ///
  /// In uk, this message translates to:
  /// **'Максимум {max} символів'**
  String fieldTooLong(int max);

  /// No description provided for @createCommunityCta.
  ///
  /// In uk, this message translates to:
  /// **'Створити спільноту'**
  String get createCommunityCta;

  /// No description provided for @communityTypeOsbb.
  ///
  /// In uk, this message translates to:
  /// **'ОСББ'**
  String get communityTypeOsbb;

  /// No description provided for @communityTypeResidentialComplex.
  ///
  /// In uk, this message translates to:
  /// **'Житловий комплекс'**
  String get communityTypeResidentialComplex;

  /// No description provided for @communityTypeDachaCooperative.
  ///
  /// In uk, this message translates to:
  /// **'Дачний кооператив'**
  String get communityTypeDachaCooperative;

  /// No description provided for @communityTypeGarageCooperative.
  ///
  /// In uk, this message translates to:
  /// **'Гаражний кооператив'**
  String get communityTypeGarageCooperative;

  /// No description provided for @communityTypeCottageTown.
  ///
  /// In uk, this message translates to:
  /// **'Котеджне містечко'**
  String get communityTypeCottageTown;

  /// No description provided for @communityTypeDormitory.
  ///
  /// In uk, this message translates to:
  /// **'Гуртожиток'**
  String get communityTypeDormitory;

  /// No description provided for @communityTypeCustom.
  ///
  /// In uk, this message translates to:
  /// **'Інше'**
  String get communityTypeCustom;

  /// No description provided for @unitCreateTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий об’єкт'**
  String get unitCreateTitle;

  /// No description provided for @unitName.
  ///
  /// In uk, this message translates to:
  /// **'Назва'**
  String get unitName;

  /// No description provided for @unitNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Будинок 223'**
  String get unitNameHint;

  /// No description provided for @unitNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть назву об’єкта'**
  String get unitNameRequired;

  /// No description provided for @unitType.
  ///
  /// In uk, this message translates to:
  /// **'Тип'**
  String get unitType;

  /// Opens the full list of object types; count is how many are not on the page
  ///
  /// In uk, this message translates to:
  /// **'Ще {count}…'**
  String unitTypeMore(String count);

  /// No description provided for @createUnitCta.
  ///
  /// In uk, this message translates to:
  /// **'Створити'**
  String get createUnitCta;

  /// No description provided for @unitTypeHouse.
  ///
  /// In uk, this message translates to:
  /// **'Будинок'**
  String get unitTypeHouse;

  /// No description provided for @unitTypeApartment.
  ///
  /// In uk, this message translates to:
  /// **'Квартира'**
  String get unitTypeApartment;

  /// No description provided for @unitTypeRoom.
  ///
  /// In uk, this message translates to:
  /// **'Кімната'**
  String get unitTypeRoom;

  /// No description provided for @unitTypeGarage.
  ///
  /// In uk, this message translates to:
  /// **'Гараж'**
  String get unitTypeGarage;

  /// No description provided for @unitTypePlot.
  ///
  /// In uk, this message translates to:
  /// **'Ділянка'**
  String get unitTypePlot;

  /// No description provided for @unitTypeBasement.
  ///
  /// In uk, this message translates to:
  /// **'Підвал'**
  String get unitTypeBasement;

  /// No description provided for @unitTypeSummerKitchen.
  ///
  /// In uk, this message translates to:
  /// **'Літня кухня'**
  String get unitTypeSummerKitchen;

  /// No description provided for @unitTypeSummerHouse.
  ///
  /// In uk, this message translates to:
  /// **'Літній будинок'**
  String get unitTypeSummerHouse;

  /// No description provided for @unitTypeShed.
  ///
  /// In uk, this message translates to:
  /// **'Сарай'**
  String get unitTypeShed;

  /// No description provided for @unitTypePool.
  ///
  /// In uk, this message translates to:
  /// **'Басейн'**
  String get unitTypePool;

  /// No description provided for @unitTypeBalcony.
  ///
  /// In uk, this message translates to:
  /// **'Балкон'**
  String get unitTypeBalcony;

  /// No description provided for @unitTypeLoggia.
  ///
  /// In uk, this message translates to:
  /// **'Лоджія'**
  String get unitTypeLoggia;

  /// No description provided for @unitTypeBathroom.
  ///
  /// In uk, this message translates to:
  /// **'Санвузол'**
  String get unitTypeBathroom;

  /// No description provided for @unitTypeCorridor.
  ///
  /// In uk, this message translates to:
  /// **'Коридор'**
  String get unitTypeCorridor;

  /// No description provided for @unitTypeStoreroom.
  ///
  /// In uk, this message translates to:
  /// **'Комора'**
  String get unitTypeStoreroom;

  /// No description provided for @unitTypeOffice.
  ///
  /// In uk, this message translates to:
  /// **'Офіс'**
  String get unitTypeOffice;

  /// No description provided for @unitTypeCustom.
  ///
  /// In uk, this message translates to:
  /// **'Інше'**
  String get unitTypeCustom;

  /// No description provided for @unitTypeGroupMain.
  ///
  /// In uk, this message translates to:
  /// **'Стоїть за адресою'**
  String get unitTypeGroupMain;

  /// No description provided for @unitTypeGroupRooms.
  ///
  /// In uk, this message translates to:
  /// **'Усередині'**
  String get unitTypeGroupRooms;

  /// No description provided for @unitTypeGroupBuildings.
  ///
  /// In uk, this message translates to:
  /// **'Окремі споруди'**
  String get unitTypeGroupBuildings;

  /// No description provided for @unitTypeGroupOther.
  ///
  /// In uk, this message translates to:
  /// **'Різне'**
  String get unitTypeGroupOther;

  /// No description provided for @unitRoleOwner.
  ///
  /// In uk, this message translates to:
  /// **'Власник'**
  String get unitRoleOwner;

  /// No description provided for @unitRoleFamily.
  ///
  /// In uk, this message translates to:
  /// **'Родина'**
  String get unitRoleFamily;

  /// No description provided for @unitRoleTenant.
  ///
  /// In uk, this message translates to:
  /// **'Орендар'**
  String get unitRoleTenant;

  /// No description provided for @unitPeople.
  ///
  /// In uk, this message translates to:
  /// **'Мешканці'**
  String get unitPeople;

  /// No description provided for @unitPeopleEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Родина, орендар, хтось із ключами. Ті, кому ця оселя теж потрібна.'**
  String get unitPeopleEmpty;

  /// No description provided for @giveAccess.
  ///
  /// In uk, this message translates to:
  /// **'Дати доступ'**
  String get giveAccess;

  /// No description provided for @unnamedMember.
  ///
  /// In uk, this message translates to:
  /// **'Мешканець'**
  String get unnamedMember;

  /// Stand-in name for someone who has not filled in a profile
  ///
  /// In uk, this message translates to:
  /// **'Мешканець {number}'**
  String unnamedMemberNumbered(int number);

  /// No description provided for @cancel.
  ///
  /// In uk, this message translates to:
  /// **'Скасувати'**
  String get cancel;

  /// Tooltip on the three-dot button that opens a menu
  ///
  /// In uk, this message translates to:
  /// **'Ще'**
  String get moreActions;

  /// No description provided for @approve.
  ///
  /// In uk, this message translates to:
  /// **'Підтвердити'**
  String get approve;

  /// No description provided for @reject.
  ///
  /// In uk, this message translates to:
  /// **'Відхилити'**
  String get reject;

  /// No description provided for @changeRole.
  ///
  /// In uk, this message translates to:
  /// **'Змінити роль'**
  String get changeRole;

  /// No description provided for @removeMember.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get removeMember;

  /// No description provided for @rejectTitle.
  ///
  /// In uk, this message translates to:
  /// **'Відхилити заявку?'**
  String get rejectTitle;

  /// Confirmation before turning a join request down
  ///
  /// In uk, this message translates to:
  /// **'{name} не отримає доступу до цієї оселі. Заявку можна буде подати ще раз.'**
  String rejectBody(String name);

  /// No description provided for @removeMemberTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити мешканця?'**
  String get removeMemberTitle;

  /// Confirmation before removing someone from an object
  ///
  /// In uk, this message translates to:
  /// **'{name} втратить доступ до цієї оселі та всього, що до неї належить.'**
  String removeMemberBody(String name);

  /// No description provided for @roleSheetTitle.
  ///
  /// In uk, this message translates to:
  /// **'Роль в оселі'**
  String get roleSheetTitle;

  /// No description provided for @rotateCode.
  ///
  /// In uk, this message translates to:
  /// **'Оновити код'**
  String get rotateCode;

  /// No description provided for @codeRotated.
  ///
  /// In uk, this message translates to:
  /// **'Код оновлено'**
  String get codeRotated;

  /// No description provided for @rotateCodeTitle.
  ///
  /// In uk, this message translates to:
  /// **'Оновити код?'**
  String get rotateCodeTitle;

  /// No description provided for @rotateCodeBody.
  ///
  /// In uk, this message translates to:
  /// **'Старий код перестане працювати. Тим, кого ще не додали, доведеться надіслати новий.'**
  String get rotateCodeBody;

  /// Shown when an object's type holds no nested objects at all
  ///
  /// In uk, this message translates to:
  /// **'Сюди не можна нічого додати'**
  String get unitAddNotAllowed;

  /// No description provided for @deleteUnit.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get deleteUnit;

  /// Confirmation before deleting an object
  ///
  /// In uk, this message translates to:
  /// **'Видалити «{label}»?'**
  String deleteUnitTitle(String label);

  /// No description provided for @deleteUnitBody.
  ///
  /// In uk, this message translates to:
  /// **'Зникне все, що всередині, і всі мешканці. Дію не можна скасувати.'**
  String get deleteUnitBody;

  /// No description provided for @unitAttributes.
  ///
  /// In uk, this message translates to:
  /// **'Що варто знати'**
  String get unitAttributes;

  /// No description provided for @unitAttributesEdit.
  ///
  /// In uk, this message translates to:
  /// **'Змінити'**
  String get unitAttributesEdit;

  /// No description provided for @unitAttributesEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Поверховість, рік побудови, матеріал стін. Запишіть те, що варто пам’ятати про цей об’єкт.'**
  String get unitAttributesEmpty;

  /// Opens the screen with an object's whole record; count is the total number of facts
  ///
  /// In uk, this message translates to:
  /// **'Показати всі {count}'**
  String unitAttributesShowAll(int count);

  /// No description provided for @unitAttributeAddTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий факт'**
  String get unitAttributeAddTitle;

  /// No description provided for @unitAttributeEditTitle.
  ///
  /// In uk, this message translates to:
  /// **'Факт'**
  String get unitAttributeEditTitle;

  /// No description provided for @unitAttributeName.
  ///
  /// In uk, this message translates to:
  /// **'Назва'**
  String get unitAttributeName;

  /// No description provided for @unitAttributeNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Номер лічильника'**
  String get unitAttributeNameHint;

  /// No description provided for @unitFactYearBuilt.
  ///
  /// In uk, this message translates to:
  /// **'Рік побудови'**
  String get unitFactYearBuilt;

  /// No description provided for @unitFactArea.
  ///
  /// In uk, this message translates to:
  /// **'Площа'**
  String get unitFactArea;

  /// No description provided for @unitFactFloors.
  ///
  /// In uk, this message translates to:
  /// **'Поверховість'**
  String get unitFactFloors;

  /// No description provided for @unitFactWalls.
  ///
  /// In uk, this message translates to:
  /// **'Матеріал стін'**
  String get unitFactWalls;

  /// No description provided for @unitFactHeating.
  ///
  /// In uk, this message translates to:
  /// **'Опалення'**
  String get unitFactHeating;

  /// No description provided for @unitAttributeNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть назву'**
  String get unitAttributeNameRequired;

  /// No description provided for @unitAttributeValue.
  ///
  /// In uk, this message translates to:
  /// **'Значення'**
  String get unitAttributeValue;

  /// No description provided for @unitAttributeValueHint.
  ///
  /// In uk, this message translates to:
  /// **'09143281'**
  String get unitAttributeValueHint;

  /// No description provided for @unitAttributeValueRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть значення'**
  String get unitAttributeValueRequired;

  /// No description provided for @editAttribute.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get editAttribute;

  /// No description provided for @deleteAttribute.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get deleteAttribute;

  /// No description provided for @deleteAttributeTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити характеристику?'**
  String get deleteAttributeTitle;

  /// Confirmation before deleting one fact about an object
  ///
  /// In uk, this message translates to:
  /// **'«{name}» зникне з опису цього об’єкта.'**
  String deleteAttributeBody(String name);

  /// No description provided for @documents.
  ///
  /// In uk, this message translates to:
  /// **'Документи'**
  String get documents;

  /// No description provided for @allDocumentsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Тут зберуться документи з усіх ваших об’єктів. Перший додають на екрані об’єкта.'**
  String get allDocumentsEmpty;

  /// No description provided for @documentsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Техпаспорт, договори, гарантії. Тут зберігаються документи, які підтверджують те, що записано вище.'**
  String get documentsEmpty;

  /// Opens the screen with all of a scope's files; count is the total
  ///
  /// In uk, this message translates to:
  /// **'Показати всі {count}'**
  String documentsShowAll(int count);

  /// No description provided for @documentSourceTitle.
  ///
  /// In uk, this message translates to:
  /// **'Додати документ'**
  String get documentSourceTitle;

  /// No description provided for @documentSourceCamera.
  ///
  /// In uk, this message translates to:
  /// **'Сфотографувати'**
  String get documentSourceCamera;

  /// No description provided for @documentSourceCameraHint.
  ///
  /// In uk, this message translates to:
  /// **'Документ переді мною'**
  String get documentSourceCameraHint;

  /// No description provided for @documentSourceGallery.
  ///
  /// In uk, this message translates to:
  /// **'З галереї'**
  String get documentSourceGallery;

  /// No description provided for @documentSourceGalleryHint.
  ///
  /// In uk, this message translates to:
  /// **'Вже сфотографовано'**
  String get documentSourceGalleryHint;

  /// No description provided for @documentSourceFile.
  ///
  /// In uk, this message translates to:
  /// **'Файл'**
  String get documentSourceFile;

  /// No description provided for @documentSourceFileHint.
  ///
  /// In uk, this message translates to:
  /// **'PDF на телефоні'**
  String get documentSourceFileHint;

  /// No description provided for @documentAddTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий документ'**
  String get documentAddTitle;

  /// No description provided for @documentEditTitle.
  ///
  /// In uk, this message translates to:
  /// **'Назва документа'**
  String get documentEditTitle;

  /// No description provided for @documentName.
  ///
  /// In uk, this message translates to:
  /// **'Назва'**
  String get documentName;

  /// No description provided for @documentNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Техпаспорт'**
  String get documentNameHint;

  /// No description provided for @documentNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть назву'**
  String get documentNameRequired;

  /// File size in kilobytes
  ///
  /// In uk, this message translates to:
  /// **'{size} КБ'**
  String documentSizeKb(String size);

  /// File size in megabytes
  ///
  /// In uk, this message translates to:
  /// **'{size} МБ'**
  String documentSizeMb(String size);

  /// When a file was uploaded, as dd.MM.yyyy
  ///
  /// In uk, this message translates to:
  /// **'Додано {date}'**
  String documentAddedOn(String date);

  /// The title a new photo starts with, the date as dd.MM.yyyy
  ///
  /// In uk, this message translates to:
  /// **'Фото {date}'**
  String documentPhotoTitle(String date);

  /// A month heading over the papers added in it; month is 1-12
  ///
  /// In uk, this message translates to:
  /// **'{month, select, 1{Січень} 2{Лютий} 3{Березень} 4{Квітень} 5{Травень} 6{Червень} 7{Липень} 8{Серпень} 9{Вересень} 10{Жовтень} 11{Листопад} 12{Грудень} other{}}'**
  String documentMonth(String month);

  /// A month heading for a year other than the current one, e.g. Серпень 2025
  ///
  /// In uk, this message translates to:
  /// **'{month} {year}'**
  String documentMonthOfYear(String month, String year);

  /// No description provided for @shareDocument.
  ///
  /// In uk, this message translates to:
  /// **'Поділитися'**
  String get shareDocument;

  /// No description provided for @editDocument.
  ///
  /// In uk, this message translates to:
  /// **'Перейменувати'**
  String get editDocument;

  /// No description provided for @deleteDocument.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get deleteDocument;

  /// No description provided for @deleteDocumentTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити документ?'**
  String get deleteDocumentTitle;

  /// Confirmation before deleting a file and its row
  ///
  /// In uk, this message translates to:
  /// **'«{title}» зникне разом із файлом. Дію не можна скасувати.'**
  String deleteDocumentBody(String title);

  /// No description provided for @contacts.
  ///
  /// In uk, this message translates to:
  /// **'Кому дзвонити'**
  String get contacts;

  /// No description provided for @allContactsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Тут зберуться номери з усіх ваших об’єктів. Перший додають на екрані об’єкта.'**
  String get allContactsEmpty;

  /// No description provided for @contactsEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Свій електрик, сантехнік, аварійна газу. Номери, які шукають, коли вже нема часу шукати.'**
  String get contactsEmpty;

  /// Opens the screen with all of a scope's contacts; count is the total
  ///
  /// In uk, this message translates to:
  /// **'Показати всі {count}'**
  String contactsShowAll(int count);

  /// No description provided for @contactAddTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий контакт'**
  String get contactAddTitle;

  /// No description provided for @contactEditTitle.
  ///
  /// In uk, this message translates to:
  /// **'Контакт'**
  String get contactEditTitle;

  /// No description provided for @contactName.
  ///
  /// In uk, this message translates to:
  /// **'Ім’я'**
  String get contactName;

  /// No description provided for @contactNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Сергій'**
  String get contactNameHint;

  /// No description provided for @contactNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть ім’я'**
  String get contactNameRequired;

  /// No description provided for @contactRole.
  ///
  /// In uk, this message translates to:
  /// **'Хто це'**
  String get contactRole;

  /// No description provided for @contactRoleHint.
  ///
  /// In uk, this message translates to:
  /// **'Електрик'**
  String get contactRoleHint;

  /// No description provided for @contactPhone.
  ///
  /// In uk, this message translates to:
  /// **'Телефон'**
  String get contactPhone;

  /// No description provided for @contactPhoneHint.
  ///
  /// In uk, this message translates to:
  /// **'+38 067 123 45 67'**
  String get contactPhoneHint;

  /// No description provided for @contactPhoneRequired.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть номер'**
  String get contactPhoneRequired;

  /// No description provided for @contactPhoneInvalid.
  ///
  /// In uk, this message translates to:
  /// **'Схоже, це не номер'**
  String get contactPhoneInvalid;

  /// No description provided for @contactCallFailed.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося відкрити набір номера'**
  String get contactCallFailed;

  /// No description provided for @copyPhone.
  ///
  /// In uk, this message translates to:
  /// **'Скопіювати номер'**
  String get copyPhone;

  /// No description provided for @phoneCopied.
  ///
  /// In uk, this message translates to:
  /// **'Номер скопійовано'**
  String get phoneCopied;

  /// No description provided for @editContact.
  ///
  /// In uk, this message translates to:
  /// **'Змінити'**
  String get editContact;

  /// No description provided for @deleteContact.
  ///
  /// In uk, this message translates to:
  /// **'Видалити'**
  String get deleteContact;

  /// No description provided for @deleteContactTitle.
  ///
  /// In uk, this message translates to:
  /// **'Видалити контакт?'**
  String get deleteContactTitle;

  /// Confirmation before deleting one contact
  ///
  /// In uk, this message translates to:
  /// **'«{name}» зникне зі списку цього об’єкта.'**
  String deleteContactBody(String name);

  /// No description provided for @unitNested.
  ///
  /// In uk, this message translates to:
  /// **'Усередині'**
  String get unitNested;

  /// No description provided for @unitNestedEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Кімната, гараж, літня кухня, ділянка. Додайте те, що ведете окремо.'**
  String get unitNestedEmpty;

  /// No description provided for @unitStartLead.
  ///
  /// In uk, this message translates to:
  /// **'Усе одразу записувати не треба. Почніть з того, що доведеться шукати першим.'**
  String get unitStartLead;

  /// First step on an empty object; type is its kind, lowercased — дім, квартира, гараж
  ///
  /// In uk, this message translates to:
  /// **'Запишіть, що це за {type}'**
  String unitStartFacts(String type);

  /// No description provided for @unitStartFactsWhy.
  ///
  /// In uk, this message translates to:
  /// **'Те, що варто пам’ятати'**
  String get unitStartFactsWhy;

  /// No description provided for @unitStartDocument.
  ///
  /// In uk, this message translates to:
  /// **'Додайте техпаспорт'**
  String get unitStartDocument;

  /// No description provided for @unitStartDocumentNested.
  ///
  /// In uk, this message translates to:
  /// **'Додайте документ'**
  String get unitStartDocumentNested;

  /// No description provided for @unitStartDocumentWhy.
  ///
  /// In uk, this message translates to:
  /// **'Документ, який підтверджує те, що записано вище'**
  String get unitStartDocumentWhy;

  /// No description provided for @unitStartContact.
  ///
  /// In uk, this message translates to:
  /// **'Додайте телефон'**
  String get unitStartContact;

  /// No description provided for @unitStartContactWhy.
  ///
  /// In uk, this message translates to:
  /// **'Номер, який шукають, коли вже нема часу шукати'**
  String get unitStartContactWhy;

  /// No description provided for @unitStartAlso.
  ///
  /// In uk, this message translates to:
  /// **'Також:'**
  String get unitStartAlso;

  /// No description provided for @unitStartAlsoNested.
  ///
  /// In uk, this message translates to:
  /// **'об’єкт усередині'**
  String get unitStartAlsoNested;

  /// No description provided for @unitAddTitle.
  ///
  /// In uk, this message translates to:
  /// **'Новий об’єкт'**
  String get unitAddTitle;

  /// No description provided for @unitAddCta.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get unitAddCta;

  /// No description provided for @unitEditTitle.
  ///
  /// In uk, this message translates to:
  /// **'Редагувати'**
  String get unitEditTitle;

  /// No description provided for @saveCta.
  ///
  /// In uk, this message translates to:
  /// **'Зберегти'**
  String get saveCta;

  /// Under the name of a nested object: what it is and which object it stands in
  ///
  /// In uk, this message translates to:
  /// **'{type} · усередині: {parent}'**
  String unitHeadInside(String type, String parent);

  /// Small caption naming the objects nested in a scope card
  ///
  /// In uk, this message translates to:
  /// **'Усередині: {items}'**
  String scopeNested(String items);

  /// How many further nested objects the caption left out
  ///
  /// In uk, this message translates to:
  /// **'+{count}'**
  String scopeNestedMore(int count);

  /// No description provided for @communityCreatedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Спільноту створено'**
  String get communityCreatedTitle;

  /// No description provided for @unitCreatedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Оселю створено'**
  String get unitCreatedTitle;

  /// No description provided for @inviteCodeLabel.
  ///
  /// In uk, this message translates to:
  /// **'Код запрошення'**
  String get inviteCodeLabel;

  /// No description provided for @inviteCodeHint.
  ///
  /// In uk, this message translates to:
  /// **'Поділіться цим кодом із мешканцями — за ним вони приєднаються до спільноти.'**
  String get inviteCodeHint;

  /// No description provided for @unitInviteCodeHint.
  ///
  /// In uk, this message translates to:
  /// **'Поділіться цим кодом із рідними — за ним вони приєднаються до оселі.'**
  String get unitInviteCodeHint;

  /// No description provided for @shareCode.
  ///
  /// In uk, this message translates to:
  /// **'Поділитися'**
  String get shareCode;

  /// Message shared with the invite code
  ///
  /// In uk, this message translates to:
  /// **'Приєднуйтесь до «{name}» у застосунку Двір. Код запрошення: {code}'**
  String shareInviteText(String name, String code);

  /// No description provided for @copyCode.
  ///
  /// In uk, this message translates to:
  /// **'Скопіювати код'**
  String get copyCode;

  /// No description provided for @codeCopied.
  ///
  /// In uk, this message translates to:
  /// **'Код скопійовано'**
  String get codeCopied;

  /// No description provided for @goToHome.
  ///
  /// In uk, this message translates to:
  /// **'На головну'**
  String get goToHome;

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
  /// **'Неправильна пошта або пароль'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailAlreadyRegistered.
  ///
  /// In uk, this message translates to:
  /// **'Ця пошта вже зареєстрована'**
  String get errorEmailAlreadyRegistered;

  /// No description provided for @errorEmailAddressInvalid.
  ///
  /// In uk, this message translates to:
  /// **'Вкажіть справжню адресу пошти'**
  String get errorEmailAddressInvalid;

  /// No description provided for @errorSignUpDisabled.
  ///
  /// In uk, this message translates to:
  /// **'Реєстрацію тимчасово вимкнено'**
  String get errorSignUpDisabled;

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

  /// No description provided for @errorInvalidInviteCode.
  ///
  /// In uk, this message translates to:
  /// **'Такого коду не існує. Перевірте його ще раз'**
  String get errorInvalidInviteCode;

  /// No description provided for @errorNotAllowed.
  ///
  /// In uk, this message translates to:
  /// **'Недостатньо прав для цієї дії'**
  String get errorNotAllowed;

  /// No description provided for @errorNotAuthenticated.
  ///
  /// In uk, this message translates to:
  /// **'Сеанс завершився. Увійдіть ще раз'**
  String get errorNotAuthenticated;

  /// No description provided for @errorLastAdmin.
  ///
  /// In uk, this message translates to:
  /// **'Це остання людина, яка керує. Спочатку призначте когось іншого'**
  String get errorLastAdmin;

  /// No description provided for @errorSelfModeration.
  ///
  /// In uk, this message translates to:
  /// **'Не можна змінити власний статус'**
  String get errorSelfModeration;

  /// No description provided for @errorScopeUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося виконати дію'**
  String get errorScopeUnknown;

  /// No description provided for @errorFileTooLarge.
  ///
  /// In uk, this message translates to:
  /// **'Файл завеликий. Максимум 20 МБ'**
  String get errorFileTooLarge;

  /// No description provided for @errorFileTypeNotAllowed.
  ///
  /// In uk, this message translates to:
  /// **'Такий тип файлу не підтримується'**
  String get errorFileTypeNotAllowed;

  /// No description provided for @errorFileMissing.
  ///
  /// In uk, this message translates to:
  /// **'Файл не знайдено. Можливо, його вже видалили'**
  String get errorFileMissing;

  /// No description provided for @errorFileUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося обробити файл'**
  String get errorFileUnknown;

  /// No description provided for @errorFileCannotOpen.
  ///
  /// In uk, this message translates to:
  /// **'Немає застосунку, який відкриє цей файл'**
  String get errorFileCannotOpen;

  /// No description provided for @errorNotABackup.
  ///
  /// In uk, this message translates to:
  /// **'Це не схоже на резервну копію'**
  String get errorNotABackup;

  /// No description provided for @errorBackupFromNewerApp.
  ///
  /// In uk, this message translates to:
  /// **'Копію зробила новіша версія застосунку. Спочатку оновіть його'**
  String get errorBackupFromNewerApp;

  /// No description provided for @errorBackupCannotWrite.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося створити копію. Можливо, на пристрої немає місця'**
  String get errorBackupCannotWrite;

  /// No description provided for @errorBackupCannotRead.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося прочитати цей файл'**
  String get errorBackupCannotRead;

  /// No description provided for @errorRestoreFailed.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося відновити з копії. Дані не змінено'**
  String get errorRestoreFailed;

  /// No description provided for @errorRestoreFilesIncomplete.
  ///
  /// In uk, this message translates to:
  /// **'Записи відновлено, але не всі файли. Спробуйте відновити з тієї самої копії ще раз'**
  String get errorRestoreFilesIncomplete;

  /// No description provided for @errorBackupUnknown.
  ///
  /// In uk, this message translates to:
  /// **'Не вдалося виконати дію з резервною копією'**
  String get errorBackupUnknown;

  /// No description provided for @errorTitle.
  ///
  /// In uk, this message translates to:
  /// **'Щось пішло не так'**
  String get errorTitle;

  /// No description provided for @retry.
  ///
  /// In uk, this message translates to:
  /// **'Повторити'**
  String get retry;
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
      <String>['en', 'uk'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
