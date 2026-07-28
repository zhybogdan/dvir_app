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
  String get scopesCommunities => 'Спільноти';

  @override
  String get scopesUnits => 'Оселі';

  @override
  String get scopePending => 'Заявка на розгляді';

  @override
  String get addScope => 'Додати';

  @override
  String get memberStatusPending => 'Очікує підтвердження';

  @override
  String get memberStatusActive => 'Активний';

  @override
  String get memberStatusRejected => 'Відхилено';

  @override
  String get memberStatusBlocked => 'Доступ закрито';

  @override
  String get profileTitle => 'Профіль';

  @override
  String get profileHint =>
      'Ім\'я побачать люди у ваших оселях — без нього ви для них просто «Мешканець».';

  @override
  String get profileName => 'Ім\'я';

  @override
  String get profileNameHint => 'Богдан Жилко';

  @override
  String get profileNameRequired => 'Введіть ім\'я';

  @override
  String get profilePhone => 'Телефон';

  @override
  String get profilePhoneHint => '+380 67 123 45 67';

  @override
  String get profileSaved => 'Збережено';

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
  String get withdrawRequest => 'Скасувати заявку';

  @override
  String get withdrawRequestTitle => 'Скасувати заявку?';

  @override
  String get withdrawRequestBody =>
      'Заявку буде видалено. Ви зможете подати її знову за тим самим кодом.';

  @override
  String get pendingOtherWays => 'Створити свою оселю або ввести інший код';

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
  String get unitTypeRoom => 'Кімната';

  @override
  String get unitTypeGarage => 'Гараж';

  @override
  String get unitTypePlot => 'Ділянка';

  @override
  String get unitTypeBasement => 'Підвал';

  @override
  String get unitTypeSummerKitchen => 'Літня кухня';

  @override
  String get unitTypeSummerHouse => 'Літній дім';

  @override
  String get unitTypeShed => 'Сарай';

  @override
  String get unitTypePool => 'Басейн';

  @override
  String get unitTypeBalcony => 'Балкон';

  @override
  String get unitTypeLoggia => 'Лоджія';

  @override
  String get unitTypeBathroom => 'Санвузол';

  @override
  String get unitTypeCorridor => 'Коридор';

  @override
  String get unitTypeStoreroom => 'Комора';

  @override
  String get unitTypeOffice => 'Офіс';

  @override
  String get unitTypeCustom => 'Інше';

  @override
  String get unitTypeGroupMain => 'Стоїть за адресою';

  @override
  String get unitTypeGroupRooms => 'Усередині';

  @override
  String get unitTypeGroupBuildings => 'Окремі споруди';

  @override
  String get unitTypeGroupOther => 'Різне';

  @override
  String get unitRoleOwner => 'Власник';

  @override
  String get unitRoleFamily => 'Родина';

  @override
  String get unitRoleTenant => 'Орендар';

  @override
  String get unitPeople => 'Мешканці';

  @override
  String get unitPeopleEmpty => 'Тут ще немає мешканців';

  @override
  String get giveAccess => 'Дати доступ';

  @override
  String unitAreaValue(String area) {
    return '$area м²';
  }

  @override
  String get unnamedMember => 'Мешканець';

  @override
  String unnamedMemberNumbered(int number) {
    return 'Мешканець $number';
  }

  @override
  String get cancel => 'Скасувати';

  @override
  String get moreActions => 'Ще';

  @override
  String get approve => 'Підтвердити';

  @override
  String get reject => 'Відхилити';

  @override
  String get changeRole => 'Змінити роль';

  @override
  String get removeMember => 'Видалити';

  @override
  String get rejectTitle => 'Відхилити заявку?';

  @override
  String rejectBody(String name) {
    return '$name не отримає доступу до цієї оселі. Заявку можна буде подати ще раз.';
  }

  @override
  String get removeMemberTitle => 'Видалити мешканця?';

  @override
  String removeMemberBody(String name) {
    return '$name втратить доступ до цієї оселі та всього, що до неї належить.';
  }

  @override
  String get roleSheetTitle => 'Роль у оселі';

  @override
  String get rotateCode => 'Оновити код';

  @override
  String get codeRotated => 'Код оновлено';

  @override
  String get rotateCodeTitle => 'Оновити код?';

  @override
  String get rotateCodeBody =>
      'Старий код перестане працювати. Тим, кого ще не додали, доведеться надіслати новий.';

  @override
  String get deleteUnit => 'Видалити';

  @override
  String deleteUnitTitle(String label) {
    return 'Видалити «$label»?';
  }

  @override
  String get deleteUnitBody =>
      'Разом з ним зникне все, що всередині, і всі мешканці. Дію не можна скасувати.';

  @override
  String get unitNested => 'Що входить';

  @override
  String get unitNestedEmpty =>
      'Кімната, гараж, літня кухня, ділянка. Додайте те, що ведете окремо.';

  @override
  String get unitAddTitle => 'Додати';

  @override
  String get unitAddCta => 'Додати';

  @override
  String get unitEditTitle => 'Редагувати';

  @override
  String get saveCta => 'Зберегти';

  @override
  String scopeNested(String items) {
    return 'Усередині: $items';
  }

  @override
  String scopeNestedMore(int count) {
    return '+$count';
  }

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
  String get errorLastAdmin =>
      'Це остання людина, яка керує. Спочатку призначте когось іншого';

  @override
  String get errorSelfModeration => 'Не можна змінити власний статус';

  @override
  String get errorScopeUnknown => 'Не вдалося виконати дію';

  @override
  String get errorTitle => 'Щось пішло не так';

  @override
  String get retry => 'Повторити';
}
