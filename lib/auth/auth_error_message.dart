import 'package:firebase_auth/firebase_auth.dart';

String authErrorMessage(Object error, {required bool isRegistration}) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-email':
        return 'Check the email format and try again.';
      case 'email-already-in-use':
        return 'That account cannot be created. Try signing in instead.';
      case 'weak-password':
        return 'Choose a stronger password that meets the project policy.';
      case 'too-many-requests':
        return 'Too many attempts. Wait a moment before trying again.';
      case 'network-request-failed':
        return 'No network connection. Reconnect and try again.';
      case 'requires-recent-login':
        return 'Confirm your current password, then try the update again.';
      case 'wrong-password':
      case 'user-not-found':
      case 'invalid-credential':
      case 'invalid-login-credentials':
        return isRegistration
            ? 'The account could not be created with those details.'
            : 'Sign-in failed. Check your credentials and try again.';
    }
  }
  if (error is StateError) {
    return 'Your session is no longer available. Sign in again.';
  }
  return 'Something went wrong. Please try again.';
}
