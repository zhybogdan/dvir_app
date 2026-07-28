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
  /// **'Заявка на розгляді'**
  String get scopePending;

  /// No description provided for @addScope.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
  String get addScope;

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

  /// No description provided for @profileHint.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я побачать люди у ваших оселях — без нього ви для них просто «Мешканець».'**
  String get profileHint;

  /// No description provided for @profileName.
  ///
  /// In uk, this message translates to:
  /// **'Ім\'я'**
  String get profileName;

  /// No description provided for @profileNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Богдан Жилко'**
  String get profileNameHint;

  /// No description provided for @profileNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть ім\'я'**
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

  /// No description provided for @profileSaved.
  ///
  /// In uk, this message translates to:
  /// **'Збережено'**
  String get profileSaved;

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
  /// **'Ваш запит на приєднання відхилили. Зверніться до адміністратора.'**
  String get rejectedBody;

  /// No description provided for @blockedTitle.
  ///
  /// In uk, this message translates to:
  /// **'Доступ закрито'**
  String get blockedTitle;

  /// No description provided for @blockedBody.
  ///
  /// In uk, this message translates to:
  /// **'Ваш доступ до цієї спільноти закрито.'**
  String get blockedBody;

  /// No description provided for @refreshCta.
  ///
  /// In uk, this message translates to:
  /// **'Оновити'**
  String get refreshCta;

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

  /// No description provided for @unitName.
  ///
  /// In uk, this message translates to:
  /// **'Назва оселі'**
  String get unitName;

  /// No description provided for @unitNameHint.
  ///
  /// In uk, this message translates to:
  /// **'Будинок 223'**
  String get unitNameHint;

  /// No description provided for @unitNameRequired.
  ///
  /// In uk, this message translates to:
  /// **'Введіть назву оселі'**
  String get unitNameRequired;

  /// No description provided for @unitType.
  ///
  /// In uk, this message translates to:
  /// **'Тип оселі'**
  String get unitType;

  /// No description provided for @unitArea.
  ///
  /// In uk, this message translates to:
  /// **'Площа, м²'**
  String get unitArea;

  /// No description provided for @unitAreaHint.
  ///
  /// In uk, this message translates to:
  /// **'72'**
  String get unitAreaHint;

  /// No description provided for @unitAreaInvalid.
  ///
  /// In uk, this message translates to:
  /// **'Введіть коректну площу'**
  String get unitAreaInvalid;

  /// No description provided for @createUnitCta.
  ///
  /// In uk, this message translates to:
  /// **'Створити оселю'**
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
  /// **'Літній дім'**
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
  /// **'Тут ще немає мешканців'**
  String get unitPeopleEmpty;

  /// No description provided for @giveAccess.
  ///
  /// In uk, this message translates to:
  /// **'Дати доступ'**
  String get giveAccess;

  /// Object area with its unit of measure
  ///
  /// In uk, this message translates to:
  /// **'{area} м²'**
  String unitAreaValue(String area);

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
  /// **'Роль у оселі'**
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
  /// **'Разом з ним зникне все, що всередині, і всі мешканці. Дію не можна скасувати.'**
  String get deleteUnitBody;

  /// No description provided for @unitNested.
  ///
  /// In uk, this message translates to:
  /// **'Що входить'**
  String get unitNested;

  /// No description provided for @unitNestedEmpty.
  ///
  /// In uk, this message translates to:
  /// **'Кімната, гараж, літня кухня, ділянка. Додайте те, що ведете окремо.'**
  String get unitNestedEmpty;

  /// No description provided for @unitAddTitle.
  ///
  /// In uk, this message translates to:
  /// **'Додати'**
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
  /// **'Невірна пошта або пароль'**
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
  /// **'Реєстрація тимчасово вимкнена'**
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
