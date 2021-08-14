import 'package:auth_repository/client_login_services/facebook/facebook_login_service.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginServiceImpl implements FacebookLoginService {
  final FacebookAuth facebookAuth;

  FacebookLoginServiceImpl(this.facebookAuth);

  Future<FacebookLoginResult> login() async {
    LoginResult facebookLogin = await facebookAuth.login();
    return FacebookLoginResult(facebookLogin.accessToken!.token);
  }
}
