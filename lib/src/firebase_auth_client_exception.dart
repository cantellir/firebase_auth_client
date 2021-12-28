class FirebaseAuthClientException {}

class InvalidEmailException extends FirebaseAuthClientException {}

class UserNotFoundException extends FirebaseAuthClientException {}

class EmailAlreadyInUseException extends FirebaseAuthClientException {}

class WrongPasswordException extends FirebaseAuthClientException {}

class WeakPasswordException extends FirebaseAuthClientException {}

class TooManyRequestsException extends FirebaseAuthClientException {}

class NetworkRequestException extends FirebaseAuthClientException {}

class AccountWithDifferentCredentialsException
    extends FirebaseAuthClientException {}
