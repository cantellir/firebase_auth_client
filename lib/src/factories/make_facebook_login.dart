import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../client_login_services/facebook/facebook_login_service.dart';
import '../client_login_services/facebook/facebook_login_service_impl.dart';

FacebookLoginService makeFacebookLogin() =>
    FacebookLoginServiceImpl(FacebookAuth.instance);
