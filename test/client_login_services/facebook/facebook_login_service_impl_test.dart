import 'package:auth_repository/client_login_services/facebook/facebook_login_service.dart';
import 'package:auth_repository/client_login_services/facebook/facebook_login_service_impl.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FacebookAuthMock extends Mock implements FacebookAuth {}

main() {
  late FacebookLoginService sut;
  late FacebookAuthMock facebookAuth;

  setUp(() {
    facebookAuth = FacebookAuthMock();
    sut = FacebookLoginServiceImpl(facebookAuth);
  });

  test('should return a FacebookLoginResult with correct token', () async {
    final mockedLoginResult = LoginResult(
        status: LoginStatus.success,
        accessToken: AccessToken(
            declinedPermissions: [],
            grantedPermissions: [],
            userId: '123',
            expires: DateTime.now(),
            lastRefresh: DateTime.now(),
            token: 'abcdefghijkl',
            applicationId: '123',
            isExpired: false));

    when(() => facebookAuth.login()).thenAnswer((_) async => mockedLoginResult);

    final result = await sut.login();

    expect(result.token, 'abcdefghijkl');
    verify(() => facebookAuth.login()).called(1);
    verifyNoMoreInteractions(facebookAuth);
  });
}
