import 'package:firebase_auth/firebase_auth.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';

mixin AuthenticationService on ServiceBase {
  FirebaseUser _authenticatedUser = null;

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}
