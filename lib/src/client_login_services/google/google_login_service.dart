import 'google_login_result.dart';

abstract class GoogleLoginService {
  Future<GoogleLoginResult> login();
}
