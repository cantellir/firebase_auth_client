import 'package:firebase_auth_client/src/firebase_auth_client_exception.dart';
import 'package:firebase_auth_client/src/client_login_services/facebook/facebook_login_result.dart';
import 'package:firebase_auth_client/src/client_login_services/google/google_login_result.dart';
import 'package:firebase_auth_client/src/firebase_auth_client.dart';
import 'package:firebase_auth_client/src/firebase_auth_client_impl.dart';
import 'package:firebase_auth_client/src/client_login_services/facebook/facebook_login_service.dart';
import 'package:firebase_auth_client/src/client_login_services/google/google_login_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockFacebookLoginService extends Mock implements FacebookLoginService {}

class MockGoogleLoginService extends Mock implements GoogleLoginService {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  late FirebaseAuthClient sut;
  late FirebaseAuth auth;
  late FacebookLoginService facebookLoginService;
  late GoogleLoginService googleLoginService;

  setUp(() {
    auth = MockFirebaseAuth();
    facebookLoginService = MockFacebookLoginService();
    googleLoginService = MockGoogleLoginService();

    sut = FirebaseAuthClientImpl(
        auth: auth,
        facebookLoginService: facebookLoginService,
        googleLoginService: googleLoginService);
  });

  setUpAll(() {
    registerFallbackValue(
        AuthCredential(providerId: 'providerId', signInMethod: 'signInMethod'));
  });

  group('login with email and password', () {
    test('should pass with correct email and password when no error occurs',
        () async {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => MockUserCredential());
      await sut.loginWithEmailAndPassword(
        email: 'fake@mail.com',
        password: '123456',
      );

      verify(() => auth.signInWithEmailAndPassword(
          email: 'fake@mail.com', password: '123456')).called(1);

      verifyNoMoreInteractions(auth);
    });

    test(
        'should throw InvalidEmailException when '
        'firebase throws invalid email', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
              FirebaseAuthException(code: FirebaseExceptionCodes.invalidEmail));

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'invalidmail',
                password: 'password',
              ),
          throwsA(isA<InvalidEmailException>()));
    });

    test(
        'should throw UserNotFoundException when '
        'firebase throws user not found', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(
              FirebaseAuthException(code: FirebaseExceptionCodes.userNotFound));

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<UserNotFoundException>()));
    });

    test(
        'should throw EmailAlreadyInUseException when '
        'firebase throws email already in use', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(FirebaseAuthException(
              code: FirebaseExceptionCodes.emailAlreadyInUse));

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<EmailAlreadyInUseException>()));
    });

    test(
        'should throw WrongPasswordException when '
        'firebase throws wrong password', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(WrongPasswordException());

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<WrongPasswordException>()));
    });

    test(
        'should throw WeakPasswordException when '
        'firebase throws weak password', () {
      when(() => auth.signInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenThrow(WeakPasswordException());

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<WeakPasswordException>()));
    });
  });

  group('register with email and password', () {
    test('should pass with correct email and password if no error occurs',
        () async {
      when(() => auth.createUserWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenAnswer((_) async => MockUserCredential());
      await sut.registerWithEmailAndPassword(
        email: 'fake@mail.com',
        password: '123456',
      );

      verify(() => auth.createUserWithEmailAndPassword(
          email: 'fake@mail.com', password: '123456')).called(1);

      verifyNoMoreInteractions(auth);
    });
  });

  group('login with facebook', () {
    test('should pass if no error occurs', () async {
      final FacebookLoginResult loginResult = FacebookLoginResult('token');
      when(() => facebookLoginService.login())
          .thenAnswer((_) async => loginResult);
      when(() => auth.signInWithCredential(any()))
          .thenAnswer((_) async => MockUserCredential());

      await sut.loginWithFacebook();

      verify(() => facebookLoginService.login()).called(1);
      verifyNoMoreInteractions(facebookLoginService);
      verify(() => auth.signInWithCredential(any())).called(1);
      verifyNoMoreInteractions(auth);
    });

    test(
        'should throw AccountWithAnotherCredentialsException when '
        'firebase throws account exists with different credential', () {
      when(() => facebookLoginService.login())
          .thenThrow(AccountWithDifferentCredentialsException());

      expect(() => sut.loginWithFacebook(),
          throwsA(isA<AccountWithDifferentCredentialsException>()));
    });

    test('should rethrow untracked exception if throws', () {
      when(() => facebookLoginService.login()).thenThrow(Exception());

      expect(() => sut.loginWithFacebook(), throwsA(isA<Exception>()));
    });
  });

  group('login with google', () {
    test('should pass if no error occurs', () async {
      final GoogleLoginResult loginResult =
          GoogleLoginResult(token: 'token', tokenId: 'tokenId');
      when(() => googleLoginService.login())
          .thenAnswer((_) async => loginResult);
      when(() => auth.signInWithCredential(any()))
          .thenAnswer((_) async => MockUserCredential());

      await sut.loginWithGoogle();

      verify(() => googleLoginService.login()).called(1);
      verifyNoMoreInteractions(googleLoginService);
      verify(() => auth.signInWithCredential(any())).called(1);
      verifyNoMoreInteractions(auth);
    });

    test('should retrhow untracked exception if throws', () {
      when(() => googleLoginService.login()).thenThrow(Exception());

      expect(() => sut.loginWithGoogle(), throwsA(isA<Exception>()));
    });
  });

  group('recover password tests', () {
    test('should pass with correct email if no error occurs', () async {
      when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
          .thenAnswer((_) async => null);

      await auth.sendPasswordResetEmail(email: 'fake@mail.com');

      verify(() => auth.sendPasswordResetEmail(email: 'fake@mail.com'))
          .called(1);
      verifyNoMoreInteractions(auth);
    });

    test('should retrhow untracked exception if throws', () {
      when(() => auth.sendPasswordResetEmail(email: any(named: 'email')))
          .thenThrow(Exception());

      expect(() => sut.recoverPassword('fake@mail.com'),
          throwsA(isA<Exception>()));
    });
  });

  group('connection error tests', () {
    test(
        'should throw TooManyRequestsException when '
        'firebase throws too many requests', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(TooManyRequestsException());

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<TooManyRequestsException>()));
    });

    test(
        'should throw NetworkRequestException when '
        'firebase throws network request failed', () {
      when(() => auth.signInWithEmailAndPassword(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(NetworkRequestException());

      expect(
          () => sut.loginWithEmailAndPassword(
                email: 'fake@mail.com',
                password: 'password',
              ),
          throwsA(isA<NetworkRequestException>()));
    });
  });
}
