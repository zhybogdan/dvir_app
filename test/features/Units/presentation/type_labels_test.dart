import 'package:dvir/features/Community/domain/types/community_type.dart';
import 'package:dvir/features/Community/presentation/community_type_l10n.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/member_status_l10n.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/unit_role_l10n.dart';
import 'package:dvir/features/Units/presentation/unit_type_l10n.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter_test/flutter_test.dart';

// The switches are exhaustive, so a missing label cannot compile. What cannot
// be caught that way is two values pointing at the same string — easy to do by
// copy-paste, and invisible until a picker shows "Кімната" twice.
void main() {
  final l10n = AppLocalizationsUk();

  void expectDistinctLabels<T>(List<T> values, String Function(T) label) {
    final labels = <String>{};

    for (final value in values) {
      final text = label(value);
      expect(text, isNotEmpty, reason: '$value');
      labels.add(text);
    }

    expect(labels, hasLength(values.length));
  }

  test('every object type is named, and named once', () {
    expectDistinctLabels(UnitType.values, (type) => type.label(l10n));
  });

  test('every object role is named, and named once', () {
    expectDistinctLabels(UnitRole.values, (role) => role.label(l10n));
  });

  test('every member status is named, and named once', () {
    expectDistinctLabels(MemberStatus.values, (status) => status.label(l10n));
  });

  test('every community type is named, and named once', () {
    expectDistinctLabels(CommunityType.values, (type) => type.label(l10n));
  });
}
