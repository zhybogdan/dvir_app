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
  String get errorWeakPassword => 'Пароль надто простий';

  @override
  String get errorEmailNotConfirmed => 'Спочатку підтвердьте пошту';

  @override
  String get errorTooManyRequests => 'Забагато спроб. Спробуйте пізніше';

  @override
  String get errorAuthUnknown => 'Не вдалося виконати дію';
}
