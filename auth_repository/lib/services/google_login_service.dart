import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginResult {
  final String? token;
  final String? tokenId;

  GoogleLoginResult({
    this.token,
    this.tokenId,
  });
}

class GoogleLoginService {
  Future<GoogleLoginResult> login() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    return GoogleLoginResult(
      token: googleAuth.accessToken,
      tokenId: googleAuth.idToken,
    );
  }
}
