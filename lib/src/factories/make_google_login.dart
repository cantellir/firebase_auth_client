import 'package:firebase_auth_client/src/client_login_services/google/google_login_service.dart';
import 'package:firebase_auth_client/src/client_login_services/google/google_login_service_impl.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleLoginService makeGoogleLogin() => GoogleLoginServiceImpl(GoogleSignIn());
