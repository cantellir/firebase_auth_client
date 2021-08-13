import 'package:auth_repository/auth_exception.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:auth_repository/services/facebook_login_service.dart';
import 'package:auth_repository/services/google_login_service.dart';
import 'package:auth_repository/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth auth;
  final FacebookLoginService facebookLoginService;
  final GoogleLoginService googleLoginService;

  FirebaseAuthRepository(
      {required this.auth,
      required this.facebookLoginService,
      required this.googleLoginService});

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _doAuth(() async {
      if (email.isEmpty) {
        throw AuthEmailException(Strings.emptyEmail);
      }
      if (password.isEmpty) {
        throw AuthPasswordException(Strings.emptyPassword);
      }
      await auth.signInWithEmailAndPassword(email: email, password: password);
    });
  }

  @override
  Future<void> loginWithFacebook() {
    return _doAuth(() async {
      final facebookLoginResult = await facebookLoginService.login();

      final AuthCredential credential =
          FacebookAuthProvider.credential(facebookLoginResult.token);
      await auth.signInWithCredential(credential);
    });
  }

  @override
  Future<void> loginWithGoogle() {
    return _doAuth(() async {
      final googleLoginResult = await googleLoginService.login();

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleLoginResult.token,
          idToken: googleLoginResult.tokenId);

      await auth.signInWithCredential(credential);
    });
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }

  @override
  Future<void> recoverPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return;
    } on FirebaseAuthException catch (e) {
      _rethrowException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _doAuth(() async {
      if (email.isEmpty) {
        throw AuthEmailException(Strings.emptyEmail);
      }
      if (password.isEmpty) {
        throw AuthPasswordException(Strings.emptyPassword);
      }
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    });
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
    switch (e.code) {
      case FirebaseExceptionCodes.invalidEmail:
        throw AuthEmailException(Strings.invalidEmail);
      case FirebaseExceptionCodes.userNotFound:
        throw AuthEmailException(Strings.userNotFound);
      case FirebaseExceptionCodes.emailAlreadyInUse:
        throw AuthEmailException(Strings.emailAlreadyInUse);
      case FirebaseExceptionCodes.wrongPassword:
        throw AuthPasswordException(Strings.invalidPassword);
      case FirebaseExceptionCodes.weakPassword:
        throw AuthPasswordException(Strings.passwordWeak);
      case FirebaseExceptionCodes.tooManyRequests:
        throw AuthNetworkException(Strings.tooManyRequest);
      case FirebaseExceptionCodes.networkRequestFailed:
        throw AuthNetworkException(Strings.checkConnection);
      case FirebaseExceptionCodes.accountExistsWithDifferentCredential:
        throw AuthException(Strings.accountExistsWithDiferentCredentials);
      default:
        throw AuthException(e.message);
    }
  }
}

class FirebaseExceptionCodes {
  static const wrongPassword = 'wrong-password';
  static const invalidEmail = 'invalid-email';
  static const userNotFound = 'user-not-found';
  static const weakPassword = 'weak-password';
  static const emailAlreadyInUse = 'email-already-in-use';
  static const tooManyRequests = 'too-many-requests';
  static const networkRequestFailed = 'network-request-failed';
  static const accountExistsWithDifferentCredential =
      'account-exists-with-different-credential';
}
