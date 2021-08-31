import 'package:google_sign_in/google_sign_in.dart';

import '../client_login_services/google/google_login_service.dart';
import '../client_login_services/google/google_login_service_impl.dart';

GoogleLoginService makeGoogleLogin() => GoogleLoginServiceImpl(GoogleSignIn());
