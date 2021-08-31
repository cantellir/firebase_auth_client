import 'package:firebase_auth/firebase_auth.dart';

import '../firebase_auth_client.dart';
import '../firebase_auth_client_impl.dart';
import 'make_facebook_login.dart';
import 'make_google_login.dart';

FirebaseAuthClient makeFirebaseAuthClient() => FirebaseAuthClientImpl(
      auth: FirebaseAuth.instance,
      facebookLoginService: makeFacebookLogin(),
      googleLoginService: makeGoogleLogin(),
    );
