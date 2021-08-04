import 'package:auth_repository/auth_exception.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:auth_repository/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Future<void> loginWithEmailAndPassword(String email, String password) {
    return _doAuth(() async {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

  @override
  Future<void> loginWithFacebook() {
    // TODO: implement loginWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<void> loginWithGoogle() {
    // TODO: implement loginWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> recoverPassword(String email) {
    // TODO: implement recoverPassword
    throw UnimplementedError();
  }

  @override
  Future<void> registerWithEmailAndPassword(String email, String password) {
    // TODO: implement registerWithEmailAndPassword
    throw UnimplementedError();
  }

  Future<void> _doAuth(Function authMethod) async {
    try {
      await authMethod();
      return;
    } on FirebaseAuthException catch (e) {
      _rethrowException(e);
    } catch (e) {
      rethrow;
    }
  }

  _rethrowException(FirebaseAuthException e) {
    String? error;

    switch (e.code) {
      case 'wrong-password':
        throw AuthPasswordException(Strings.validationInvalidPassword);
      case 'invalid-email':
        throw AuthEmailException(Strings.invalidEmail);
      case 'user-not-found':
        throw AuthEmailException(Strings.validationUserNotFound);
      case 'weak-password':
        throw AuthPasswordException(Strings.invalidPasswordWeak);
      case 'email-already-in-use':
        throw AuthEmailException(Strings.validationEmailInUse);
      case 'too-many-requests':
        throw AuthNetworkException(Strings.errorToManyRequest);
      case 'network-request-failed':
        throw AuthNetworkException(Strings.errorCheckConnection);
      case 'account-exists-with-different-credential':
        throw AuthException(Strings.errorAccountExistsDiferentCredentials);
      default:
        throw AuthException(e.message);
    }
  }
}
