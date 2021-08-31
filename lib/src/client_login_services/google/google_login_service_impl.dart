import 'package:google_sign_in/google_sign_in.dart';

import 'google_login_result.dart';
import 'google_login_service.dart';

class GoogleLoginServiceImpl implements GoogleLoginService {
  final GoogleSignIn _googleSignIn;

  GoogleLoginServiceImpl(this._googleSignIn);

  Future<GoogleLoginResult> login() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    return GoogleLoginResult(
      token: googleAuth.accessToken,
      tokenId: googleAuth.idToken,
    );
  }
}
