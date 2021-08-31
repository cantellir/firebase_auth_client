library auth_repository;

abstract class FirebaseAuthClient {
  Future<void> loginWithGoogle();
  Future<void> loginWithFacebook();
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> recoverPassword(String email);
  Future<void> logout();
}
