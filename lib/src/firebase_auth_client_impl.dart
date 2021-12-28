import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_auth_client.dart';
import 'firebase_auth_client_exception.dart';
import 'client_login_services/facebook/facebook_login_service.dart';
import 'client_login_services/google/google_login_service.dart';
import 'firebase_auth_client.dart';

class FirebaseAuthClientImpl implements FirebaseAuthClient {
  final FirebaseAuth auth;
  final FacebookLoginService facebookLoginService;
  final GoogleLoginService googleLoginService;

  FirebaseAuthClientImpl(
      {required this.auth,
      required this.facebookLoginService,
      required this.googleLoginService});

  @override
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _doAuth(() async {
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
    return _doAuth(() async {
      await auth.sendPasswordResetEmail(email: email);
    });
  }

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _doAuth(() async {
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
    }
  }

  Future<FirebaseUser?> getUser() async {
    final currentUser = auth.currentUser;

    if (currentUser == null) {
      return null;
    }

    return FirebaseUser(
      uid: currentUser.uid,
      email: currentUser.email!,
    );
  }

  _rethrowException(FirebaseAuthException e) {
    switch (e.code) {
      case FirebaseExceptionCodes.invalidEmail:
        throw InvalidEmailException();
      case FirebaseExceptionCodes.userNotFound:
        throw UserNotFoundException();
      case FirebaseExceptionCodes.emailAlreadyInUse:
        throw EmailAlreadyInUseException();
      case FirebaseExceptionCodes.wrongPassword:
        throw WrongPasswordException();
      case FirebaseExceptionCodes.weakPassword:
        throw WeakPasswordException();
      case FirebaseExceptionCodes.tooManyRequests:
        throw TooManyRequestsException();
      case FirebaseExceptionCodes.networkRequestFailed:
        throw NetworkRequestException();
      case FirebaseExceptionCodes.accountExistsWithDifferentCredential:
        throw AccountWithDifferentCredentialsException();
      default:
        throw FirebaseAuthClientException();
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
