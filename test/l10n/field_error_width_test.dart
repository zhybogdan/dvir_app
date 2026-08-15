import 'dart:io';

import 'package:dvir/app/theme.dart';
import 'package:dvir/core/utils/field_lengths.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// `DvTextField` reserves exactly one line under every field (`helperText: ' '`)
// so a form does not jump when an error appears, and `errorMaxLines: 1` in the
// theme holds the error to that line. The cost is that a message too long to
// fit is not wrapped but ellipsised — a refusal the person cannot read.
//
// So the length of these strings is a layout constraint, not a matter of taste,
// and this is where it is enforced. A new validator message belongs in the list
// below; one that does not fit belongs in fewer words.

/// The narrowest case the wording has to survive: a 320dp phone, the app's own
/// screen padding either side, and the field's horizontal content padding.
const double _errorWidth = 320 - AppSpacing.md * 2 - AppSpacing.md * 2;

Future<void> _loadInter() async {
  final bytes = await File('assets/fonts/Inter.ttf').readAsBytes();
  await (FontLoader(
        'Inter',
      )..addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer))))
      .load();
}

void main() {
  // Measured in the real typeface: the test font every widget test falls back
  // to draws each glyph one em wide, which would make every string here fail by
  // about double.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await _loadInter();
  });

  test('every error a field can show fits the line reserved for it', () {
    final l10n = AppLocalizationsUk();
    final theme = AppTheme.light;
    final style = (theme.textTheme.bodySmall ?? const TextStyle()).merge(
      theme.inputDecorationTheme.errorStyle,
    );

    final messages = <String>[
      l10n.emailRequired,
      l10n.invalidEmail,
      l10n.passwordRequired,
      l10n.passwordTooShort,
      l10n.passwordsDontMatch,
      l10n.profileNameRequired,
      l10n.profilePhoneInvalid,
      l10n.unitNameRequired,
      l10n.joinCodeRequired,
      l10n.communityNameRequired,
      l10n.documentNameRequired,
      l10n.contactNameRequired,
      l10n.contactPhoneRequired,
      l10n.contactPhoneInvalid,
      l10n.unitAttributeNameRequired,
      l10n.unitAttributeValueRequired,
      // The widest number any capped field passes in, so the longest this
      // message ever renders.
      l10n.fieldTooLong(FieldLength.address),
    ];

    for (final message in messages) {
      // Laid out unconstrained: what is wanted here is the width the message
      // actually needs, and a bounded layout reports the bound instead.
      final painter = TextPainter(
        text: TextSpan(text: message, style: style),
        textDirection: TextDirection.ltr,
        textScaler: const TextScaler.linear(AppTextScale.max),
        maxLines: 1,
      )..layout();

      expect(
        painter.width,
        lessThanOrEqualTo(_errorWidth),
        reason:
            '«$message» needs ${painter.width.round()}dp of the '
            '${_errorWidth.round()}dp a field error gets — shorten it',
      );

      painter.dispose();
    }
  });
}
