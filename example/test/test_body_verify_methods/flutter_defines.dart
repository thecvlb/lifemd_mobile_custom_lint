// ignore_for_file: prefer-single-widget-per-file, avoid-top-level-members-in-tests
class VerificationResult {}

verify(Function() matchingInvocations) => VerificationResult();

verifyInOrder(List<Function()> matchingInvocations) => VerificationResult();
