import 'dart:async';

import 'package:dvir/features/Members/application/unit_members_controller.dart';
import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/dv_invite_code_card.dart';
import 'package:dvir/features/Units/application/unit_controller.dart';
import 'package:dvir/features/Units/domain/models/unit.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/features/Units/domain/types/unit_type.dart';
import 'package:dvir/features/Units/presentation/components/unit_invite_section.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// An object's invite code is folded away while nobody but its owner is in it.
// The rule came out of someone opening a room and finding a large code for a
// place nobody will ever be invited to — which is what made a nested object
// read as a second house. What is checked here is the fold and, more
// importantly, which way it errs while the answer is still unknown.

const _code = '51CE8B1E';

const _unit = Unit(id: 'u1', label: 'Гараж 1', type: UnitType.garage);

UnitMemberView _person(String userId, {UnitRole role = UnitRole.family}) =>
    UnitMemberView(
      membership: UnitMembership(
        id: 'um-$userId',
        unitId: 'u1',
        userId: userId,
        role: role,
        status: MemberStatus.active,
      ),
    );

final _owner = _person('me', role: UnitRole.owner);

/// [people] null leaves the residents list loading forever, which is the state
/// the section has to have an answer for.
Future<void> _pump(WidgetTester tester, {List<UnitMemberView>? people}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        unitMembersProvider.overrideWith(
          (ref, unitId) => people ?? Completer<List<UnitMemberView>>().future,
        ),
        unitInviteCodeProvider.overrideWith((ref, unitId) => _code),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: UnitInviteSection(unit: _unit)),
      ),
    ),
  );

  await tester.pump();
}

void main() {
  final l10n = AppLocalizationsUk();

  testWidgets('an object holding only its owner offers a line, not a code', (
    tester,
  ) async {
    await _pump(tester, people: [_owner]);

    expect(find.text(l10n.giveAccess), findsOneWidget);
    expect(find.byType(DvInviteCodeCard), findsNothing);
  });

  testWidgets('the line opens into the code on tap', (tester) async {
    await _pump(tester, people: [_owner]);

    await tester.tap(find.text(l10n.giveAccess));
    await tester.pump();

    expect(find.byType(DvInviteCodeCard), findsOneWidget);
    expect(find.text(_code), findsOneWidget);
  });

  // A garage that really is let out has a second person in it already, so no
  // rule about types is needed — it shows its code by itself.
  testWidgets('a second person opens it without being asked', (tester) async {
    await _pump(tester, people: [_owner, _person('other')]);

    expect(find.byType(DvInviteCodeCard), findsOneWidget);
    expect(find.text(l10n.giveAccess), findsNothing);
  });

  // The one that matters: unknown must fold the same way "alone" does. Erring
  // the other way would flash the code on screen for every object on every
  // open, which is precisely what the fold exists to prevent.
  testWidgets('an unread residents list keeps the code out of sight', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text(l10n.giveAccess), findsOneWidget);
    expect(find.byType(DvInviteCodeCard), findsNothing);
  });
}
