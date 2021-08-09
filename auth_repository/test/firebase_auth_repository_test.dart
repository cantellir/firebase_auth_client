import 'package:auth_repository/auth_exception.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:auth_repository/firebase_auth_repository.dart';
import 'package:auth_repository/services/facebook_login_service.dart';
import 'package:auth_repository/services/google_login_service.dart';
import 'package:auth_repository/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FirebaseAuthMock extends Mock implements FirebaseAuth {}

class FacebookLoginServiceMock extends Mock implements FacebookLoginService {}

class GoogleLoginServiceMock extends Mock implements GoogleLoginService {}

class UserCredentialMock extends Mock implements UserCredential {}

void main() {
  late AuthRepository sut;
  late FirebaseAuthMock auth;
  FacebookLoginServiceMock facebookLoginService;
  GoogleLoginServiceMock googleLoginService;

  setUp(() {
    auth = FirebaseAuthMock();
    facebookLoginService = FacebookLoginServiceMock();
    googleLoginService = GoogleLoginServiceMock();

    sut = FirebaseAuthRepository(
        auth: auth,
        facebookLoginService: facebookLoginService,
        googleLoginService: googleLoginService);
  });

  group('login with email and password', () {
    test('should call login with email and password with correct values',
        () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => UserCredentialMock());
      await sut.loginWithEmailAndPassword('fake@mail.com', '123456');

      verify(() => auth.signInWithEmailAndPassword(
          email: 'fake@mail.com', password: '123456'));

      verifyNoMoreInteractions(auth);
    });

    test(
        'should trhow AuthEmailException with correct message if e-mail '
        'is empty', () async {
      expect(
          () => sut.loginWithEmailAndPassword('', '123456'),
          throwsA(isA<AuthEmailException>()
              .having((e) => e.error, 'message', Strings.emptyEmail)));

      verifyZeroInteractions(auth);
    });

    test(
        'should trhow AuthPasswordException with correct message if e-mail '
        'is empty', () async {
      expect(
          () => sut.loginWithEmailAndPassword('fake@mail.com', ''),
          throwsA(isA<AuthPasswordException>()
              .having((e) => e.error, 'message', Strings.emptyPassword)));

      verifyZeroInteractions(auth);
    });

    test(
        'should throw AuthEmailException with correct message if firebase '
        'throws invalid email', () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
              FirebaseAuthException(code: FirebaseExceptionCodes.invalidEmail));

      expect(
          () => sut.loginWithEmailAndPassword('invalidmail', 'password'),
          throwsA(isA<AuthEmailException>()
              .having((e) => e.error, 'message', Strings.invalidEmail)));
    });

    test(
        'should throw AuthEmailException with correct message if firebase '
        'throws user not found', () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
              FirebaseAuthException(code: FirebaseExceptionCodes.userNotFound));

      expect(
          () => sut.loginWithEmailAndPassword('fake@mail.com', 'password'),
          throwsA(isA<AuthEmailException>()
              .having((e) => e.error, 'message', Strings.userNotFound)));
    });

    test(
        'should throw AuthEmailException with correct message if firebase '
        'throws email already in use', () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(
              code: FirebaseExceptionCodes.emailAlreadyInUse));

      expect(
          () => sut.loginWithEmailAndPassword('fake@mail.com', 'password'),
          throwsA(isA<AuthEmailException>()
              .having((e) => e.error, 'message', Strings.emailAlreadyInUse)));
    });

    test(
        'should throw AuthPasswordException with correct message if firebase '
        'throws wrong password', () async {
      when(() =>
          auth.signInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'))).thenThrow(
          FirebaseAuthException(code: FirebaseExceptionCodes.wrongPassword));

      expect(
          () => sut.loginWithEmailAndPassword('fake@mail.com', 'password'),
          throwsA(isA<AuthPasswordException>()
              .having((e) => e.error, 'message', Strings.invalidPassword)));
    });

    test(
        'should throw AuthPasswordException with correct message if firebase '
        'throws weak password', () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
              FirebaseAuthException(code: FirebaseExceptionCodes.weakPassword));

      expect(
          () => sut.loginWithEmailAndPassword('fake@mail.com', 'password'),
          throwsA(isA<AuthPasswordException>()
              .having((e) => e.error, 'message', Strings.passwordWeak)));
    });
  });
}
