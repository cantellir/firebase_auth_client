import 'package:firebase_auth_client/src/client_login_services/google/google_login_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginServiceImpl implements GoogleLoginService {
  final GoogleSignIn googleSignIn;

  GoogleLoginServiceImpl(this.googleSignIn);

  Future<GoogleLoginResult> login() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    return GoogleLoginResult(
      token: googleAuth.accessToken,
      tokenId: googleAuth.idToken,
    );
  }
}
