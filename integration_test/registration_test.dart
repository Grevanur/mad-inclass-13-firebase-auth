import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:in_class_13_auth/main.dart' as app;

const testEmail = String.fromEnvironment('MAD_TEST_EMAIL');
const initialPassword = String.fromEnvironment('MAD_TEST_INITIAL_PASSWORD');

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('registers a Firebase user and opens the protected profile', (
    tester,
  ) async {
    await app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('Welcome back'), findsOneWidget);
    await tester.tap(find.byKey(const Key('switchModeButton')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('emailField')), testEmail);
    await tester.enterText(
      find.byKey(const Key('passwordField')),
      initialPassword,
    );
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      initialPassword,
    );
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pumpAndSettle(const Duration(seconds: 8));

    expect(find.text('You’re signed in'), findsOneWidget);
    expect(find.text(testEmail), findsOneWidget);
  });
}
