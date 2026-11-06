import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_class_13_auth/auth/auth_client.dart';
import 'package:in_class_13_auth/screens/auth_gate.dart';

class FakeAuthClient implements AuthClient {
  final _controller = StreamController<AppUser?>.broadcast();
  AppUser? _currentUser;
  int registerCalls = 0;
  int signInCalls = 0;
  int signOutCalls = 0;

  @override
  Stream<AppUser?> get authStateChanges => _controller.stream;

  @override
  AppUser? get currentUser => _currentUser;

  void emit(AppUser? user) {
    _currentUser = user;
    _controller.add(user);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    registerCalls++;
    emit(AppUser(uid: 'registered-user', email: email.trim()));
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    signInCalls++;
    emit(AppUser(uid: 'signed-in-user', email: email.trim()));
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    emit(null);
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  Future<void> dispose() => _controller.close();
}

Widget testApp(AuthClient authClient) {
  return MaterialApp(home: AuthGate(authClient: authClient));
}

void main() {
  testWidgets('auth state gates signed-out and signed-in screens', (
    tester,
  ) async {
    final auth = FakeAuthClient();
    addTearDown(auth.dispose);
    await tester.pumpWidget(testApp(auth));

    auth.emit(null);
    await tester.pump();
    expect(find.text('Welcome back'), findsOneWidget);

    auth.emit(const AppUser(uid: '1', email: 'graduate@example.com'));
    await tester.pump();
    expect(find.text('You’re signed in'), findsOneWidget);
    expect(find.text('graduate@example.com'), findsOneWidget);
  });

  testWidgets('invalid sign-in is blocked before calling the service', (
    tester,
  ) async {
    final auth = FakeAuthClient();
    addTearDown(auth.dispose);
    await tester.pumpWidget(testApp(auth));
    auth.emit(null);
    await tester.pump();

    await tester.enterText(find.byKey(const Key('emailField')), 'not-an-email');
    await tester.enterText(find.byKey(const Key('passwordField')), '123');
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Use at least 6 characters'), findsOneWidget);
    expect(auth.signInCalls, 0);
  });

  testWidgets('valid sign-in calls the service and shows the profile', (
    tester,
  ) async {
    final auth = FakeAuthClient();
    addTearDown(auth.dispose);
    await tester.pumpWidget(testApp(auth));
    auth.emit(null);
    await tester.pump();

    await tester.enterText(
      find.byKey(const Key('emailField')),
      'graduate@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret1');
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(auth.signInCalls, 1);
    expect(find.text('graduate@example.com'), findsOneWidget);
  });

  testWidgets('registration requires confirmation and calls the service', (
    tester,
  ) async {
    final auth = FakeAuthClient();
    addTearDown(auth.dispose);
    await tester.pumpWidget(testApp(auth));
    auth.emit(null);
    await tester.pump();

    await tester.tap(find.byKey(const Key('switchModeButton')));
    await tester.pump();
    await tester.enterText(
      find.byKey(const Key('emailField')),
      'newuser@example.com',
    );
    await tester.enterText(find.byKey(const Key('passwordField')), 'secret1');
    await tester.enterText(
      find.byKey(const Key('confirmPasswordField')),
      'secret1',
    );
    await tester.tap(find.byKey(const Key('submitButton')));
    await tester.pump();

    expect(auth.registerCalls, 1);
    expect(find.text('newuser@example.com'), findsOneWidget);
  });

  testWidgets('sign-out returns to the authentication screen', (tester) async {
    final auth = FakeAuthClient();
    addTearDown(auth.dispose);
    await tester.pumpWidget(testApp(auth));
    auth.emit(const AppUser(uid: '1', email: 'graduate@example.com'));
    await tester.pump();

    await tester.tap(find.byKey(const Key('signOutButton')));
    await tester.pump();

    expect(auth.signOutCalls, 1);
    expect(find.text('Welcome back'), findsOneWidget);
  });
}
