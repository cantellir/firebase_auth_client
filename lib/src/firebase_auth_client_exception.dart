class FirebaseAuthClientException {}

class EmptyEmailException extends FirebaseAuthClientException {}

class InvalidEmailException extends FirebaseAuthClientException {}

class UserNotFoundException extends FirebaseAuthClientException {}

class EmailAlreadyInUseException extends FirebaseAuthClientException {}

class EmptyPasswordException extends FirebaseAuthClientException {}

class WrongPasswordException extends FirebaseAuthClientException {}

class WeakPasswordException extends FirebaseAuthClientException {}

class TooManyRequestsException extends FirebaseAuthClientException {}

class NetworkRequestException extends FirebaseAuthClientException {}

class AccountWithDifferentCredentialsException
    extends FirebaseAuthClientException {}

// class AuthPasswordException extends AuthException {
//   AuthPasswordException(String? error) : super(error);
// }

// class AuthEmailException extends AuthException {
//   AuthEmailException(String? error) : super(error);
// }

// class AuthNetworkException extends AuthException {
//   AuthNetworkException(String? error) : super(error);
// }
