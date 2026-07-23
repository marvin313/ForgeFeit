String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (email.isEmpty) {
    return 'Enter your email address.';
  }
  final emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailPattern.hasMatch(email)) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? validatePassword(String? value, {bool requireMinimumLength = true}) {
  final password = value ?? '';
  if (password.isEmpty) {
    return 'Enter your password.';
  }
  if (requireMinimumLength && password.length < 8) {
    return 'Use at least 8 characters.';
  }
  return null;
}

String describeAuthError(Object error) {
  final raw = error.toString().replaceFirst('AuthException(message: ', '');
  final message = raw
      .replaceAll(RegExp(r', statusCode:.*$'), '')
      .replaceAll(RegExp(r'\)$'), '')
      .trim();
  final lower = message.toLowerCase();

  if (lower.contains('invalid login') ||
      lower.contains('invalid credentials')) {
    return 'That email and password do not match.';
  }
  if (lower.contains('email not confirmed')) {
    return 'Confirm your email before logging in.';
  }
  if (lower.contains('already registered') ||
      lower.contains('already exists')) {
    return 'An account already exists for that email. Try logging in.';
  }
  if (lower.contains('network') ||
      lower.contains('socket') ||
      lower.contains('connection')) {
    return 'ForgeFit could not reach the server. Check your connection and try again.';
  }
  if (message.isEmpty || message == error.runtimeType.toString()) {
    return 'Something went wrong. Please try again.';
  }
  return message;
}
