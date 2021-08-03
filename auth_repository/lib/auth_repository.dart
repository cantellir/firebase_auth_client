library auth_repository;

abstract class AuthRepository {
  Future<void> loginWithGoogle();
  Future<void> loginWithFacebook();
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> registerWithEmailAndPassword(String email, String password);
  Future<void> recoverPassword(String email);
  Future<void> logout();
}
