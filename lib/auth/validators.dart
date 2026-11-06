String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) return 'Email is required';
  final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailPattern.hasMatch(email)) return 'Enter a valid email address';
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < 6) return 'Use at least 6 characters';
  return null;
}

String? validateConfirmedPassword(String? value, String expected) {
  final baseError = validatePassword(value);
  if (baseError != null) return baseError;
  if (value != expected) return 'Passwords do not match';
  return null;
}
