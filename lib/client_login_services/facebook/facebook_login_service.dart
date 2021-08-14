class FacebookLoginResult {
  final String token;

  FacebookLoginResult(this.token);
}

abstract class FacebookLoginService {
  Future<FacebookLoginResult> login();
}
