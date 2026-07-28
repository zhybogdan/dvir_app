import 'package:dvir/features/Members/domain/models/unit_member_view.dart';
import 'package:dvir/features/Members/presentation/components/unit_member_tile.dart';
import 'package:dvir/features/Shared/domain/models/profile.dart';
import 'package:dvir/features/Shared/domain/types/member_status.dart';
import 'package:dvir/features/Shared/presentation/dv_menu.dart';
import 'package:dvir/features/Units/domain/models/unit_membership.dart';
import 'package:dvir/features/Units/domain/types/unit_role.dart';
import 'package:dvir/l10n/app_localizations.dart';
import 'package:dvir/l10n/app_localizations_uk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// The rules themselves are covered in member_permissions_test. What is checked
// here is the other half: that the tile asks them, and shows what the answer
// allows. A menu left standing on a call the database refuses is the failure
// these rules exist to prevent, and no amount of testing the functions catches
// it.
UnitMemberView _member(
  String userId, {
  UnitRole role = UnitRole.family,
  MemberStatus status = MemberStatus.active,
  String? fullName,
}) => UnitMemberView(
  membership: UnitMembership(
    id: 'um-$userId',
    unitId: 'u1',
    userId: userId,
    role: role,
    status: status,
  ),
  profile: Profile(id: userId, fullName: fullName),
);

Future<void> _pump(
  WidgetTester tester, {
  required UnitMemberView view,
  required List<UnitMemberView> all,
  required bool isOwner,
  String? myUserId = 'me',
  int position = 1,
}) => tester.pumpWidget(
  ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: UnitMemberTile(
          unitId: 'u1',
          view: view,
          all: all,
          position: position,
          isOwner: isOwner,
          myUserId: myUserId,
        ),
      ),
    ),
  ),
);

void main() {
  final owner = _member('me', role: UnitRole.owner, fullName: 'Богдан');
  final resident = _member('other', fullName: 'Оксана');
  final applicant = _member('guest', status: MemberStatus.pending);

  testWidgets('an owner may act on somebody else', (tester) async {
    await _pump(tester, view: resident, all: [owner, resident], isOwner: true);

    expect(find.byType(DvMenu), findsOneWidget);
  });

  // The last owner can neither step down nor remove themselves, which leaves
  // nothing to offer — and a menu of disabled items is worse than none.
  testWidgets('the last owner is offered nothing on their own row', (
    tester,
  ) async {
    await _pump(tester, view: owner, all: [owner, resident], isOwner: true);

    expect(find.byType(DvMenu), findsNothing);
  });

  testWidgets('a second owner gives the first their menu back', (tester) async {
    final second = _member('other', role: UnitRole.owner, fullName: 'Оксана');

    await _pump(tester, view: owner, all: [owner, second], isOwner: true);

    expect(find.byType(DvMenu), findsOneWidget);
  });

  testWidgets('a request is answered in the open, not behind a menu', (
    tester,
  ) async {
    await _pump(
      tester,
      view: applicant,
      all: [owner, applicant],
      isOwner: true,
    );

    final l10n = AppLocalizationsUk();
    expect(find.text(l10n.approve), findsOneWidget);
    expect(find.text(l10n.reject), findsOneWidget);
  });

  testWidgets('a resident who is not the owner is offered nothing', (
    tester,
  ) async {
    await _pump(
      tester,
      view: applicant,
      all: [owner, applicant],
      isOwner: false,
      myUserId: 'other',
    );

    final l10n = AppLocalizationsUk();
    expect(find.byType(DvMenu), findsNothing);
    expect(find.text(l10n.approve), findsNothing);
  });

  testWidgets('someone with no profile is named by their position', (
    tester,
  ) async {
    await _pump(
      tester,
      view: applicant,
      all: [owner, applicant],
      isOwner: true,
      position: 2,
    );

    expect(find.text(AppLocalizationsUk().unnamedMemberNumbered(2)), findsOne);
  });
}
