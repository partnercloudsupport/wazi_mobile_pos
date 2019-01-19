import 'package:firebase_auth/firebase_auth.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:google_sign_in/google_sign_in.dart';

mixin AuthenticationService on ServiceBase {
  bool _isLoading = false;

  setLoading(bool value) {
    this._isLoading = value;
    notifyListeners();
  }

  bool get isLoading {

    return this._isLoading;
  }

  FirebaseUser _authenticatedUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String _verificationId;

  bool isAuthenticating = false;
  bool isRegistering = false;

  FirebaseUser get authenticatedUser {
    return this._authenticatedUser;
  }

  Future<bool> login(String userName, String password) async {
    isAuthenticating = true;
    notifyListeners();
    bool result = false;
    await _auth
        .signInWithEmailAndPassword(email: userName, password: password)
        .then((FirebaseUser user) {
      if (user != null) {
        this._authenticatedUser = user;
        print(user.uid);
        result = true;
      }
    }).whenComplete(() {
      isAuthenticating = false;
    }).catchError((Object error) {
      isAuthenticating = false;
      print(error.toString());
      result = false;
    });
    notifyListeners();
    return result;
  }

  Future<bool> loginGoogle() async {
    isAuthenticating = true;
    notifyListeners();

    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _auth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    this._authenticatedUser = user;

    if (user != null) {
      print("signed in " + user.displayName);
      return true;
    } else
      return false;
  }

  void signOut() async {
    await this._auth.signOut();
  }

  Future<bool> registerUser(String email, String password) async {
    this.isRegistering = true;
    notifyListeners();
    bool result = false;
    print("registering user started...");
    await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((FirebaseUser user) {
      if (user != null) {
        this._authenticatedUser = user;

        print(user.uid);
        result = true;
      }
    }).whenComplete(() {
      this.isRegistering = false;
    }).catchError((Object error) {
      print("this is an error!");
      this.isRegistering = false;
      print(error.toString());
      result = false;
    });
    notifyListeners();
    return result;
  }

  Future<void> sendCodeToPhone(String mobileNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      print("code sent to " + mobileNumber);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      print("time out");
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: mobileNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}
