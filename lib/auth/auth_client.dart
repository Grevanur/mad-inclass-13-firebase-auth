class AppUser {
  const AppUser({required this.uid, required this.email});

  final String uid;
  final String email;
}

abstract interface class AuthClient {
  Stream<AppUser?> get authStateChanges;
  AppUser? get currentUser;

  Future<void> register({required String email, required String password});
  Future<void> signIn({required String email, required String password});
  Future<void> signOut();
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
