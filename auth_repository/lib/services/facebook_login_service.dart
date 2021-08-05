import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginResult {
  final String token;

  FacebookLoginResult(this.token);
}

class FacebookLoginService {
  Future<FacebookLoginResult> login() async {
    final facebookLogin = await FacebookAuth.instance.login();
    return FacebookLoginResult(facebookLogin.accessToken!.token);
  }
}
