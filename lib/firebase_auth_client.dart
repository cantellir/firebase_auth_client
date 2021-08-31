library auth_repository;

import 'package:firebase_auth_client/firebase_user.dart';

export 'factories/make_firebase_auth_client.dart';
export 'firebase_user.dart';

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
  Future<FirebaseUser?> getUser();
}
