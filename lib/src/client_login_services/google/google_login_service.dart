class GoogleLoginResult {
  final String? token;
  final String? tokenId;

  GoogleLoginResult({
    this.token,
    this.tokenId,
  });
}

abstract class GoogleLoginService {
  Future<GoogleLoginResult> login();
}
