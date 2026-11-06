import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:in_class_13_auth/main.dart' as app;

const testEmail = String.fromEnvironment('MAD_TEST_EMAIL');
const initialPassword = String.fromEnvironment('MAD_TEST_INITIAL_PASSWORD');
const updatedPassword = String.fromEnvironment('MAD_TEST_UPDATED_PASSWORD');

Future<void> waitFor(
  WidgetTester tester,
  Finder finder, {
  int attempts = 30,
}) async {
  for (var attempt = 0; attempt < attempts; attempt++) {
    await tester.pump(const Duration(milliseconds: 500));
    if (finder.evaluate().isNotEmpty) return;
  }
  expect(finder, findsOneWidget);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'reauthenticates, changes password, and rejects the old password',
    (tester) async {
      await app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      if (find.text('You’re signed in').evaluate().isNotEmpty) {
        await tester.tap(find.byKey(const Key('signOutButton')));
        await waitFor(tester, find.text('Welcome back'));
      }

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
      await waitFor(tester, find.text('You’re signed in'));
      expect(find.text('You’re signed in'), findsOneWidget);

      await tester.tap(find.byKey(const Key('changePasswordButton')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const Key('currentPasswordField')),
        initialPassword,
      );
      await tester.enterText(
        find.byKey(const Key('newPasswordField')),
        updatedPassword,
      );
      await tester.enterText(
        find.byKey(const Key('confirmNewPasswordField')),
        updatedPassword,
      );
      await tester.tap(find.byKey(const Key('confirmPasswordUpdateButton')));
      await waitFor(tester, find.text('Password updated successfully.'));
      expect(find.text('Password updated successfully.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('signOutButton')));
      await waitFor(tester, find.text('Welcome back'));
      expect(find.text('Welcome back'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('emailField')), testEmail);
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        initialPassword,
      );
      await tester.tap(find.byKey(const Key('submitButton')));
      await waitFor(
        tester,
        find.text('Sign-in failed. Check your credentials and try again.'),
      );
      expect(
        find.text('Sign-in failed. Check your credentials and try again.'),
        findsOneWidget,
      );
    },
  );
}
