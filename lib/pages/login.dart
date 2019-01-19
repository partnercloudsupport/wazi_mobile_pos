import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GenericForm _loginForm;
  String email;
  String password;
  Future<FirebaseUser> user;
  bool _isLoading;

  StreamController<bool> _streamController = StreamController<bool>.broadcast();

  @override
  initState() {
    super.initState();
    _isLoading = false;
  }

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        image: AssetImage("assets/bg_portrait.jpg"),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop));
  }

  Widget _buildLoginOption(BuildContext context, AppState state) {
    if (this._loginForm == null) {
      state.registerForm(FormModel(key: "loginform"));

      this._loginForm = GenericForm(
        model: state.getForm("loginform"),
        formTitle: "Welcome",
        subTitle:
            "please login using your email address to access your profile",
        addHeader: false,
        autoSize: true,
        blur: true,
      );

      _loginForm.addField(
          name: "email address",
          autoCorrect: true,
          initialValue: "bmrmozz@gmail.com",
          inputAction: TextInputAction.next,
          icon: Icons.email,
          inputType: TextInputType.emailAddress,
          fieldKey: "email",
          required: true,
          onSave: (String value) {
            state.getForm("loginform").setFieldValue("email", value);
            email = value;
          },
          validator: (String value) {},
          regexPattern:
              "^[a-zA-Z0-9.!#\$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\$",
          exampleValue: "example@example.com");

      _loginForm.addField(
          name: "password",
          icon: Icons.lock,
          initialValue: "1qazxsw2",
          inputAction: TextInputAction.done,
          fieldKey: "password",
          required: true,
          onSave: (String value) {
            state.getForm("loginform").setFieldValue("password", value);
            password = value;
          },
          validator: (String value) {},
          obscureText: true);

      _loginForm.addButton(
          text: "Login",
          loadingStream: _streamController.stream,
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          type: FormButtonType.progressButton,
          onPressed: () {
            _onSubmit(context, state);
          });
    }

    return Center(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.only(top: 75.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _loginForm,
          ],
        ),
      ),
    );
  }

  void _onSubmit(BuildContext context, AppState appState) {
    var formKey = appState.getForm("loginform").formKey;

    if (!formKey.currentState.validate()) {
      return;
    }

    formKey.currentState.save();
    //need to indicate

    setState(() {
      _isLoading = true;
      _streamController.sink.add(_isLoading);
    });

    login(email, password, appState).then((bool result) {
      setState(() {
        _isLoading = false;
        _streamController.sink.add(_isLoading);
      });

      if (result == true) {
        _streamController.close();
        Navigator.pushNamedAndRemoveUntil(
            context, "/home", ModalRoute.withName('/landing'));
      } else {
        appState.showAlertDialog(
            context: context,
            title: "Incorrect username / password",
            description:
                "please re-verify your username or password and try again");
      }
    });
  }

  Future<bool> login(String email, String password, AppState state) async {
    var loggedIn = await state.login(email, password);
    if (loggedIn) {
      await setActiveContent(state);
      return loggedIn;
    } else {
      return null;
    }
  }

  Future<bool> setActiveContent(AppState appState) async {
    await appState.userService.loadActiveUser(appState.authenticatedUser.uid);
    await appState.merchantService
        .setActiveMerchant(appState.userService.activeUser);

    return true;
  }

  List<Widget> _getLoginControls(BuildContext context, AppState state) {
    List<Widget> loginControls = <Widget>[];

    loginControls.add(_buildLoginOption(context, state));

    return loginControls;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        var controls = this._getLoginControls(context, state);

        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              alignment: Alignment.center,

              // margin: EdgeInsets.all(10.00),
              decoration: BoxDecoration(image: _buildBackgroundImage()),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  decoration: BoxDecoration(color: Colors.transparent),
                  child: ListView(
                    children: <Widget>[controls[0]],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

//
