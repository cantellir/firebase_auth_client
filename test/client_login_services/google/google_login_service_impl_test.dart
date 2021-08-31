import 'package:firebase_auth_client/src/client_login_services/google/google_login_service.dart';
import 'package:firebase_auth_client/src/client_login_services/google/google_login_service_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

main() {
  late GoogleLoginService sut;
  late MockGoogleSignIn googleSignIn;

  setUp(() {
    googleSignIn = MockGoogleSignIn();
    sut = GoogleLoginServiceImpl(googleSignIn);
  });

  test('should return a GoogleLoginResult with correct token', () async {
    final result = await sut.login();

    expect(result.token, isNotEmpty);
    expect(result.tokenId, isNotEmpty);
  });
}
