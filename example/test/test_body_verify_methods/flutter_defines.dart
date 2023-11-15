// ignore_for_file: prefer-single-widget-per-file, avoid-top-level-members-in-tests
class VerificationResult {}

typedef Verify = VerificationResult Function<T>(
  T Function() matchingInvocations,
);

Verify get verify {
  return <T>(T Function() matchingInvocations) {
    return VerificationResult();
  };
}

List<VerificationResult> Function<T>(
  List<T Function()> recordedInvocations,
) get verifyInOrder {
  return <T>(List<T Function()> recordedInvocations) {
    return <VerificationResult>[];
  };
}
