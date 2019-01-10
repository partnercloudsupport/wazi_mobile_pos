import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';
import 'package:wazi_mobile_pos/widgets/general/loading_circle.dart';
import 'package:wazi_mobile_pos/widgets/general/value_item.dart';
import 'package:wazi_mobile_pos/widgets/logo_title.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginState _loginState = LoginState.login;
  GenericForm _registerForm;
  double _targetWidth;

  String email;
  String password;
  bool _termsAccepted = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _registerFormState = GlobalKey<FormState>();

  DecorationImage _buildBackgroundImage() {
    Orientation thisOrientation = MediaQuery.of(context).orientation;
    String backgroundImage = thisOrientation == Orientation.landscape
        ? "assets/bg_landscape.jpg"
        : "assets/bg_portrait.jpg";

    return DecorationImage(
        image: AssetImage(backgroundImage),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop));
  }

  Widget _buildUserNameField() {
    return TextFormField(
      initialValue: "bmrmozz@gmail.com",
      decoration: InputDecoration(
          labelText: "Username",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          suffixIcon: Icon(Icons.person)),
      autofocus: false,
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return "Username is required";
        }
      },
      onSaved: (String value) {
        email = value;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      initialValue: "1qazxsw2",
      decoration: InputDecoration(
          labelText: "Password",
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
          suffixIcon: Icon(Icons.lock)),
      autofocus: false,
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return "Password is required";
        }
      },
      onSaved: (String value) {
        password = value;
      },
    );
  }

  Widget _buildButtonOptions() {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState model) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                child: Text("Login"),
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    if (_loginState != LoginState.login)
                      _loginState = LoginState.login;
                    else
                      _onSubmit(context, model);
                  });
                }),
            SizedBox(
              width: 12.0,
            ),
            RaisedButton(
                child: Text("Register"),
                textColor: Colors.white,
                color: Theme.of(context).primaryColor,
                onPressed: () {
                  setState(() {
                    _loginState = LoginState.register;
                  });
                })
          ],
        );
      },
    );
  }

  Widget _buildLoginOption(BuildContext context, AppState state) {
    return Form(
      key: _formKey,
      child: Container(
        alignment: Alignment.center,
        // margin: EdgeInsets.only(top: 25.0),
        child: SingleChildScrollView(
          child: AnimatedContainer(
            width: this._targetWidth,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              children: <Widget>[
                LogoTitle(
                  title: "Wazi Merchant",
                  image: "assets/lf_logo.png",
                ),
                SizedBox(
                  height: 8.0,
                ),
                _buildUserNameField(),
                SizedBox(
                  height: 10,
                ),
                _buildPasswordField(),
                SizedBox(
                  height: 8.0,
                ),
                _buildButtonOptions()
              ],
            ),
            duration: Duration(seconds: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterOption(BuildContext context, AppState state) {
    if (_registerForm == null) {
      var fieldValues = <ValueItem>[];
      _registerForm = GenericForm(_registerFormState, fieldValues);

      // _registerForm.addField(
      //     name: "business name",
      //     icon: Icons.store,
      //     fieldKey: "businessname",
      //     onSave: (String value) {
      //       _registerForm.setFieldValue("businessname", value);
      //     },
      //     validator: (String value) {});

      _registerForm.addField(
          name: "first name",
          icon: Icons.person,
          fieldKey: "firstname",
          onSave: (String value) {
            _registerForm.setFieldValue("firstname", value);
          },
          validator: (String value) {});

      _registerForm.addField(
          name: "last name",
          icon: Icons.person,
          fieldKey: "lastname",
          onSave: (String value) {
            _registerForm.setFieldValue("lastname", value);
          },
          validator: (String value) {});

      _registerForm.addField(
          name: "email address",
          icon: Icons.email,
          inputType: TextInputType.emailAddress,
          fieldKey: "email",
          onSave: (String value) {
            _registerForm.setFieldValue("email", value);
          },
          validator: (String value) {});

      _registerForm.addField(
          name: "phone number",
          icon: Icons.phone,
          inputType: TextInputType.phone,
          fieldKey: "phonenumber",
          onSave: (String value) {
            _registerForm.setFieldValue("phonenumber", value);
          },
          validator: (String value) {});

      _registerForm.addField(
          name: "password",
          icon: Icons.lock,
          fieldKey: "password",
          onSave: (String value) {
            _registerForm.setFieldValue("password", value);
          },
          validator: (String value) {},
          obscureText: true);

      _registerForm.addField(
          name: "confirm password",
          icon: Icons.lock,
          fieldKey: "confirmpassword",
          onSave: (String value) {
            _registerForm.setFieldValue("confirmpassword", value);
          },
          validator: (String value) {},
          obscureText: true);
      print("added fields");

      _registerForm.addButton(
          text: "Back",
          color: Theme.of(context).accentColor,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              this._loginState = LoginState.login;
            });
          });

      _registerForm.addButton(
          text: "Register",
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            setState(() {
              _registerFormState.currentState.save();
              print("register user clicked...");
              // this._loginState = LoginState.register;
              state
                  .registerUser(_registerForm.getFieldValue("email"),
                      _registerForm.getFieldValue("password"))
                  .then((bool value) {
                if (value) {
                  setState(() {
                    this._loginState = LoginState.login;
                  });

                  // Scaffold.of(context).showSnackBar(SnackBar(
                  //   content: Text("Welcome to WaziMerchant!"),
                  //   duration: Duration(seconds: 3),
                  // ));
                } else {
                  // Scaffold.of(context).showSnackBar(SnackBar(
                  //   content:
                  //       Text("Oops, something went wrong please try again..."),
                  //   duration: Duration(seconds: 3),
                  // ));
                }
              });
            });
          });

      print("added buttons");
    }

    return state.isRegistering
        ? LoadingCircle(
            displayText: "Saving...",
          )
        : _registerForm;
  }

  Widget _buildLoginCard(BuildContext context, AppState state) {
    switch (_loginState) {
      case LoginState.login:
        return _buildLoginOption(context, state);
      case LoginState.register:
        return _buildRegisterOption(context, state);
    }

    return null;
  }

  void _onSubmit(BuildContext context, AppState appState) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    appState.login(email, password).then((bool loggedIn) {
      if (loggedIn) {
        print(appState.isAuthenticating);
        print("Logged in!!!");
        appState.setMerchantInfo(appState.authenticatedUser);
        appState.initialize();
      } else {
        print("not logged in...");
        print(appState.isAuthenticating);
      }
    }).whenComplete(() {
      print(appState.isAuthenticating);
      if (appState.authenticatedUser != null) {
        Navigator.of(context).pushReplacementNamed("/home");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    this._targetWidth = currentWidth > 768.0 ? 500 : currentWidth * 0.80;

    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          body: Container(
            padding: EdgeInsets.all(10.00),
            decoration: BoxDecoration(image: _buildBackgroundImage()),
            child: _buildLoginCard(context, state),
          ),
        );
      },
    );
  }
}

enum LoginState { login, register }
