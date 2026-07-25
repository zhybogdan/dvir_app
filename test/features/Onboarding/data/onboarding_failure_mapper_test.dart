import 'package:dvir/core/error/failures.dart';
import 'package:dvir/features/Onboarding/data/onboarding_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

// The RPCs raise custom SQLSTATEs so the mapping never depends on message text;
// a typo here would degrade a real reason to a generic "unknown".
void main() {
  group('scopeFailureReasonFrom', () {
    test('maps the custom RPC codes', () {
      expect(
        scopeFailureReasonFrom('DV001'),
        ScopeFailureReason.invalidInviteCode,
      );
      expect(scopeFailureReasonFrom('DV002'), ScopeFailureReason.notAllowed);
      expect(
        scopeFailureReasonFrom('DV003'),
        ScopeFailureReason.notAuthenticated,
      );
      expect(scopeFailureReasonFrom('DV004'), ScopeFailureReason.lastAdmin);
      expect(
        scopeFailureReasonFrom('DV005'),
        ScopeFailureReason.selfModeration,
      );
    });

    test('treats a blocked RLS write as "not allowed"', () {
      expect(scopeFailureReasonFrom('42501'), ScopeFailureReason.notAllowed);
    });

    test('degrades unknown and missing codes instead of throwing', () {
      expect(scopeFailureReasonFrom(null), ScopeFailureReason.unknown);
      expect(scopeFailureReasonFrom(''), ScopeFailureReason.unknown);
      expect(scopeFailureReasonFrom('P0001'), ScopeFailureReason.unknown);
    });
  });
}
