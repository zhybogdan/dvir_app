// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Двір';

  @override
  String get homePlaceholder => 'Основа готова — функції незабаром';

  @override
  String get signIn => 'Увійти';

  @override
  String get signUp => 'Зареєструватися';

  @override
  String get signOut => 'Вийти';

  @override
  String get email => 'Ел. пошта';

  @override
  String get password => 'Пароль';

  @override
  String get confirmPassword => 'Підтвердьте пароль';

  @override
  String get welcomeBack => 'З поверненням';

  @override
  String get createAccount => 'Створити акаунт';

  @override
  String get dontHaveAccount => 'Немає акаунту? Зареєструйтесь';

  @override
  String get alreadyHaveAccount => 'Вже маєте акаунт? Увійдіть';

  @override
  String get emailRequired => 'Введіть ел. пошту';

  @override
  String get invalidEmail => 'Введіть коректну ел. пошту';

  @override
  String get passwordRequired => 'Введіть пароль';

  @override
  String get passwordTooShort => 'Щонайменше 6 символів';

  @override
  String get passwordsDontMatch => 'Паролі не збігаються';

  @override
  String get confirmEmailTitle => 'Перевірте пошту';

  @override
  String confirmEmailBody(String email) {
    return 'Ми надіслали лист на $email. Відкрийте посилання, щоб завершити реєстрацію.';
  }

  @override
  String get backToSignIn => 'Повернутися до входу';

  @override
  String get onboardingTitle => 'З чого почнемо?';

  @override
  String get onboardingCreateCommunity => 'Створити спільноту';

  @override
  String get onboardingCreateUnit => 'Створити оселю';

  @override
  String get onboardingJoinByCode => 'Приєднатися за кодом';

  @override
  String get pendingApprovalTitle => 'Заявку надіслано';

  @override
  String get pendingApprovalBody =>
      'Очікуйте підтвердження. Ми відкриємо доступ, щойно заявку розглянуть.';

  @override
  String get rejectedTitle => 'Заявку відхилено';

  @override
  String get rejectedBody =>
      'Ваш запит на приєднання відхилили. Зверніться до адміністратора.';

  @override
  String get blockedTitle => 'Доступ закрито';

  @override
  String get blockedBody => 'Ваш доступ до цієї спільноти закрито.';

  @override
  String get refreshCta => 'Оновити';

  @override
  String get joinByCodeIntro =>
      'Введіть код запрошення, який вам надіслали, щоб приєднатися до спільноти або оселі.';

  @override
  String get joinCodeHint => 'A3F9C1B2';

  @override
  String get joinCodeRequired => 'Введіть код запрошення';

  @override
  String get joinCta => 'Приєднатися';

  @override
  String get communityName => 'Назва спільноти';

  @override
  String get communityNameHint => 'ОСББ «Каштан»';

  @override
  String get communityNameRequired => 'Введіть назву спільноти';

  @override
  String get communityType => 'Тип спільноти';

  @override
  String get communityAddress => 'Адреса';

  @override
  String get communityAddressHint => 'вул. Хрещатик, 1';

  @override
  String get communityCity => 'Місто';

  @override
  String get communityCityHint => 'Київ';

  @override
  String get optional => 'необов’язково';

  @override
  String get createCommunityCta => 'Створити спільноту';

  @override
  String get communityTypeOsbb => 'ОСББ';

  @override
  String get communityTypeResidentialComplex => 'Житловий комплекс';

  @override
  String get communityTypeDachaCooperative => 'Дачний кооператив';

  @override
  String get communityTypeGarageCooperative => 'Гаражний кооператив';

  @override
  String get communityTypeCottageTown => 'Котеджне містечко';

  @override
  String get communityTypeDormitory => 'Гуртожиток';

  @override
  String get communityTypeCustom => 'Інше';

  @override
  String get unitName => 'Назва оселі';

  @override
  String get unitNameHint => 'Будинок 223';

  @override
  String get unitNameRequired => 'Введіть назву оселі';

  @override
  String get unitType => 'Тип оселі';

  @override
  String get unitArea => 'Площа, м²';

  @override
  String get unitAreaHint => '72';

  @override
  String get unitAreaInvalid => 'Введіть коректну площу';

  @override
  String get createUnitCta => 'Створити оселю';

  @override
  String get unitTypeHouse => 'Будинок';

  @override
  String get unitTypeApartment => 'Квартира';

  @override
  String get unitTypePlot => 'Ділянка';

  @override
  String get unitTypeGarage => 'Гараж';

  @override
  String get unitTypeOffice => 'Офіс';

  @override
  String get unitTypeCustom => 'Інше';

  @override
  String get communityCreatedTitle => 'Спільноту створено';

  @override
  String get unitCreatedTitle => 'Оселю створено';

  @override
  String get inviteCodeLabel => 'Код запрошення';

  @override
  String get inviteCodeHint =>
      'Поділіться цим кодом із мешканцями — за ним вони приєднаються до спільноти.';

  @override
  String get unitInviteCodeHint =>
      'Поділіться цим кодом із рідними — за ним вони приєднаються до оселі.';

  @override
  String get shareCode => 'Поділитися';

  @override
  String shareInviteText(String name, String code) {
    return 'Приєднуйтесь до «$name» у застосунку Двір. Код запрошення: $code';
  }

  @override
  String get copyCode => 'Скопіювати код';

  @override
  String get codeCopied => 'Код скопійовано';

  @override
  String get goToHome => 'На головну';

  @override
  String get errorNetwork => 'Немає з’єднання з інтернетом';

  @override
  String get errorServer => 'Помилка сервера. Спробуйте пізніше';

  @override
  String get errorNotFound => 'Не знайдено';

  @override
  String get errorUnknown => 'Неочікувана помилка';

  @override
  String get errorInvalidCredentials => 'Невірна пошта або пароль';

  @override
  String get errorEmailAlreadyRegistered => 'Ця пошта вже зареєстрована';

  @override
  String get errorEmailAddressInvalid => 'Вкажіть справжню адресу пошти';

  @override
  String get errorSignUpDisabled => 'Реєстрація тимчасово вимкнена';

  @override
  String get errorWeakPassword => 'Пароль надто простий';

  @override
  String get errorEmailNotConfirmed => 'Спочатку підтвердьте пошту';

  @override
  String get errorTooManyRequests => 'Забагато спроб. Спробуйте пізніше';

  @override
  String get errorAuthUnknown => 'Не вдалося виконати дію';

  @override
  String get errorInvalidInviteCode =>
      'Такого коду не існує. Перевірте його ще раз';

  @override
  String get errorNotAllowed => 'Недостатньо прав для цієї дії';

  @override
  String get errorNotAuthenticated => 'Сеанс завершився. Увійдіть ще раз';

  @override
  String get errorScopeUnknown => 'Не вдалося виконати дію';

  @override
  String get errorTitle => 'Щось пішло не так';

  @override
  String get retry => 'Повторити';
}
