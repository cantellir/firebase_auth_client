class AuthException {
  String? error;

  AuthException(this.error);
}

class AuthPasswordException extends AuthException {
  AuthPasswordException(String? error) : super(error);
}

class AuthEmailException extends AuthException {
  AuthEmailException(String? error) : super(error);
}

class AuthNetworkException extends AuthException {
  AuthNetworkException(String? error) : super(error);
}
