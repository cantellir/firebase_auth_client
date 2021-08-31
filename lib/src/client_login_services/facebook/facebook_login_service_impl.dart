import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'facebook_login_result.dart';
import 'facebook_login_service.dart';

class FacebookLoginServiceImpl implements FacebookLoginService {
  final FacebookAuth _facebookAuth;

  FacebookLoginServiceImpl(this._facebookAuth);

  Future<FacebookLoginResult> login() async {
    LoginResult facebookLogin = await _facebookAuth.login();
    return FacebookLoginResult(facebookLogin.accessToken!.token);
  }
}
