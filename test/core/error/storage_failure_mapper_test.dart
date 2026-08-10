import 'package:dvir/core/error/failures.dart';
import 'package:dvir/core/error/storage_failure_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

// The two limits the bucket enforces — 20 MB and the mime whitelist (`0010`) —
// are the only refusals a person can act on, and Storage reports both without a
// code of its own. Losing them means telling someone "something went wrong" about
// a file they could simply have made smaller.
void main() {
  test('a status Storage is explicit about maps on its own', () {
    expect(storageFailureReasonFrom('413', ''), StorageFailureReason.tooLarge);
    expect(
      storageFailureReasonFrom('415', ''),
      StorageFailureReason.typeNotAllowed,
    );
    expect(storageFailureReasonFrom('404', ''), StorageFailureReason.missing);
    expect(
      storageFailureReasonFrom('403', ''),
      StorageFailureReason.notAllowed,
    );
  });

  test('a bad request is told apart by what it says', () {
    expect(
      storageFailureReasonFrom(
        '400',
        'The object exceeded the maximum allowed size',
      ),
      StorageFailureReason.tooLarge,
    );
    expect(
      storageFailureReasonFrom('400', 'mime type image/gif is not supported'),
      StorageFailureReason.typeNotAllowed,
    );
  });

  // Matching a sentence is a guess about wording upstream, so it has to fail
  // softly: a reworded message costs a vaguer error, never a wrong one.
  test('a bad request nobody recognises stays unknown', () {
    expect(
      storageFailureReasonFrom('400', 'something else entirely'),
      StorageFailureReason.unknown,
    );
    expect(storageFailureReasonFrom(null, ''), StorageFailureReason.unknown);
  });
}
