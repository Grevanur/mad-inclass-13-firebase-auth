import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:in_class_13_auth/main.dart' as app;

const testEmail = String.fromEnvironment('MAD_TEST_EMAIL');
const updatedPassword = String.fromEnvironment('MAD_TEST_UPDATED_PASSWORD');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('signs in with the updated password and shows the profile', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 5));

    if (find.text('Welcome back').evaluate().isNotEmpty) {
      await tester.enterText(find.byKey(const Key('emailField')), testEmail);
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        updatedPassword,
      );
      await tester.tap(find.byKey(const Key('submitButton')));
      await tester.pumpAndSettle(const Duration(seconds: 8));
    }

    expect(find.text('You’re signed in'), findsOneWidget);
    expect(find.text(testEmail), findsOneWidget);
  });
}
