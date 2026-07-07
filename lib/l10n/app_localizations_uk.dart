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
  String get passwordTooShort => 'Пароль має містити щонайменше 6 символів';

  @override
  String get passwordsDontMatch => 'Паролі не збігаються';
}
