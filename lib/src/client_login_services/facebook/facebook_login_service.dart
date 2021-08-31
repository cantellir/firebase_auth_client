import 'facebook_login_result.dart';

abstract class FacebookLoginService {
  Future<FacebookLoginResult> login();
}
