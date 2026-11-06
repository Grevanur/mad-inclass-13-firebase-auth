import 'package:firebase_auth/firebase_auth.dart';

import 'auth_client.dart';

class AuthService implements AuthClient {
  AuthService({FirebaseAuth? firebaseAuth})
    : _auth = firebaseAuth ?? FirebaseAuth.instance {
    authStateChanges = _auth.authStateChanges().map(_toAppUser);
  }

  final FirebaseAuth _auth;

  @override
  late final Stream<AppUser?> authStateChanges;

  static AppUser? _toAppUser(User? user) {
    final email = user?.email;
    if (user == null || email == null) return null;
    return AppUser(uid: user.uid, email: email);
  }

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Future<void> register({
    required String email,
    required String password,
  }) async {
    await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    if (user == null || email == null) {
      throw StateError('A signed-in email account is required.');
    }
    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }
}
