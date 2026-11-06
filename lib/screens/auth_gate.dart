import 'package:flutter/material.dart';

import '../auth/auth_client.dart';
import 'authentication_screen.dart';
import 'profile_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key, required this.authClient});

  final AuthClient authClient;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AppUser?>(
      stream: authClient.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Unable to check sign-in status. Check your connection and restart the app.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        final user = snapshot.data;
        if (user == null) {
          return AuthenticationScreen(authClient: authClient);
        }
        return ProfileScreen(authClient: authClient, user: user);
      },
    );
  }
}
