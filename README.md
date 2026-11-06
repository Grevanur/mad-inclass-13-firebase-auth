# Campus Access

Campus Access is the Flutter submission for MAD In-Class Activity 13B. It uses Firebase Email/Password Authentication to register and sign in a test user, restore authentication state, protect the profile screen, display the signed-in email, update the password after reauthentication, and sign out.

## Implemented requirements

- Firebase initializes before `runApp` with generated platform options.
- `AuthService` centralizes registration, sign-in, sign-out, auth-state changes, current-user access, reauthentication, and password updates.
- `AuthGate` listens to one stable auth-state stream and switches between signed-out and protected UI.
- Registration and sign-in forms validate email and the six-character assignment baseline.
- Async actions disable duplicate submissions and provide visible loading feedback.
- Firebase errors are translated into useful messages without exposing raw exceptions or account-enumeration details.
- The profile shows the current Firebase email and supports password update and sign-out.
- Password changes require the current password and reauthenticate before updating.
- Android release networking is declared in the main manifest.

## Prerequisites

- Flutter 3.47.2 or a compatible stable release
- Android SDK and an Android emulator or device
- Firebase CLI and FlutterFire CLI
- A disposable Firebase project with Email/Password sign-in enabled

## Firebase setup

From the project root:

```bash
flutter pub get
flutterfire configure --platforms=android
```

Select the Firebase project used for the class activity. In Firebase Console, open **Authentication**, choose **Sign-in method**, and enable **Email/Password**. Do not store passwords, service-account credentials, or signing secrets in the repository.

## Run and test

Start an Android emulator or connect a device, then run:

```bash
flutter analyze
flutter test
flutter run
```

The local test suite covers form validation, registration, sign-in, auth-state routing, protected profile display, and sign-out with a fake authentication client. The `integration_test/` suite exercises a disposable account against the configured Firebase project on Android.

Pass disposable live-test credentials at runtime rather than committing them:

```bash
flutter test integration_test/password_update_test.dart -d DEVICE_ID \
  --dart-define=MAD_TEST_EMAIL=YOUR_TEST_EMAIL \
  --dart-define=MAD_TEST_INITIAL_PASSWORD=YOUR_INITIAL_TEST_PASSWORD \
  --dart-define=MAD_TEST_UPDATED_PASSWORD=YOUR_UPDATED_TEST_PASSWORD
```

The registration, session, and sign-out integration tests use the same runtime variables. Never reuse a personal or production credential.

## Manual test sequence

1. Register a fictional test account and confirm the profile shows its email.
2. Sign out and sign in again with the same credentials.
3. Try a malformed email, a password shorter than six characters, and incorrect credentials.
4. Restart the app while signed in and verify the profile returns after the loading state.
5. Update the password by entering the current password and a new matching password.
6. Sign out. Verify the old password fails and the new password succeeds.
7. Sign out again and verify the profile is no longer accessible.

Never include test passwords in screenshots, logs, commits, or the reflection document.

## Build the submission APK

```bash
flutter build apk --release
```

The standard output is `build/app/outputs/flutter-apk/app-release.apk`.

Install that exact release APK on the test device and repeat the full manual test sequence before submission.

## Architecture

- `lib/auth/auth_service.dart` owns Firebase Authentication calls.
- `lib/auth/auth_client.dart` defines the boundary used by UI and tests.
- `lib/screens/auth_gate.dart` protects signed-in-only UI from auth state.
- `lib/screens/authentication_screen.dart` implements registration and sign-in.
- `lib/screens/profile_screen.dart` implements profile, password update, and sign-out.
- `test/` contains validation and widget-flow tests.
- `integration_test/` contains live Firebase Android checks with runtime-supplied disposable credentials.

Authentication proves identity. It does not authorize access to arbitrary data. If user-specific Firestore data is added later, it must be protected by server-enforced rules such as matching `request.auth.uid` to the document owner.

