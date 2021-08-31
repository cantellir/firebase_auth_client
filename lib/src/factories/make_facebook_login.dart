import 'package:firebase_auth_client/src/client_login_services/facebook/facebook_login_service.dart';
import 'package:firebase_auth_client/src/client_login_services/facebook/facebook_login_service_impl.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

FacebookLoginService makeFacebookLogin() =>
    FacebookLoginServiceImpl(FacebookAuth.instance);
