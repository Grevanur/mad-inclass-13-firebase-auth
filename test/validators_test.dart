import 'package:flutter_test/flutter_test.dart';
import 'package:in_class_13_auth/auth/validators.dart';

void main() {
  group('email validation', () {
    test('rejects blank and malformed email values', () {
      expect(validateEmail(''), isNotNull);
      expect(validateEmail('student@'), isNotNull);
      expect(validateEmail('student@example.com'), isNull);
    });
  });

  group('password validation', () {
    test('enforces the six-character assignment baseline', () {
      expect(validatePassword('12345'), isNotNull);
      expect(validatePassword('123456'), isNull);
    });

    test('requires matching confirmation', () {
      expect(validateConfirmedPassword('abcdef', 'abcdeg'), isNotNull);
      expect(validateConfirmedPassword('abcdef', 'abcdef'), isNull);
    });
  });
}
