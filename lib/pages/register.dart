import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_page_indicator/flutter_page_indicator.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/merchant/merchant_model.dart';
import 'package:wazi_mobile_pos/models/system/user_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GenericForm _registerForm;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
        image: AssetImage("assets/bg_portrait.jpg"),
        fit: BoxFit.cover,
        colorFilter:
            ColorFilter.mode(Colors.white.withOpacity(0.5), BlendMode.dstATop));
  }

  Widget _buildRegisterOption(BuildContext context, AppState state) {
    if (_registerForm == null) {
      state.registerForm(FormModel(key: "registerForm"));

      _registerForm = GenericForm(
        model: state.getForm("registerForm"),
        addHeader: false,
        headerImage: "assets/lf_logo.png",
        autoSize: true,
        blur: true,
        formTitle: "Welcome",
        subTitle: "please complete the below details to join the community",
      );

      _registerForm.addField(
          name: "first name",
          textCapitalization: TextCapitalization.words,
          icon: Icons.person,
          fieldKey: "firstname",
          onSave: (String value) {
            state.getForm("registerForm").setFieldValue("firstname", value);
          },
          required: true,
          validator: (String value) {});

      _registerForm.addField(
          name: "email address",
          autoCorrect: true,
          icon: Icons.email,
          inputType: TextInputType.emailAddress,
          fieldKey: "email",
          required: true,
          onSave: (String value) {
            state.getForm("registerForm").setFieldValue("email", value);
          },
          validator: (String value) {},
          regexPattern:
              "^[a-zA-Z0-9.!#\$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*\$",
          exampleValue: "example@example.com");

      _registerForm.addField(
          name: "phone number",
          autoCorrect: true,
          icon: Icons.phone,
          inputType: TextInputType.phone,
          fieldKey: "phonenumber",
          required: true,
          onSave: (String value) {
            state.getForm("registerForm").setFieldValue("phonenumber", value);
          },
          validator: (String value) {});

      _registerForm.addField(
          name: "password",
          icon: Icons.lock,
          fieldKey: "password",
          required: true,
          onSave: (String value) {
            state.getForm("registerForm").setFieldValue("password", value);
          },
          validator: (String value) {},
          obscureText: true);

      _registerForm.addButton(
          text: "Register",
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          onPressed: () {
            var formKey = state.getForm("registerForm").formKey;

            setState(() {
              if (formKey.currentState.validate()) {
                formKey.currentState.save();
                state
                    .registerUser(
                        state.getForm("registerForm").getFieldValue("email"),
                        state.getForm("registerForm").getFieldValue("password"))
                    .then((bool value) {
                  if (value) {
                    var thisUser = UserModel(
                        id: Uuid().v4(),
                        email: state
                            .getForm("registerForm")
                            .getFieldValue("email"),
                        lastname: state
                            .getForm("registerForm")
                            .getFieldValue("lastname"),
                        name: state
                            .getForm("registerForm")
                            .getFieldValue("firstname"),
                        phoneNumber: state
                            .getForm("registerForm")
                            .getFieldValue("phonenumber"),
                        registeredDate: DateTime.now().toUtc(),
                        password: state
                            .getForm("registerForm")
                            .getFieldValue("password"),
                        role: UserRole.owner);

                    var thisMerchant = MerchantModel.fromUser(thisUser);
                    //now we need to save to firestore..
                    // var uid =

                    //we need to login the user that was just created to ensure it is authenticated
                    state
                        .login(
                            state
                                .getForm("registerForm")
                                .getFieldValue("email"),
                            state
                                .getForm("registerForm")
                                .getFieldValue("password"))
                        .then((bool loggedIn) {
                      state.merchantService
                          .saveMerchant(thisMerchant)
                          .then((bool result) {
                        if (result) {
                          thisUser.merchantId = thisMerchant.id;
                          thisUser.userId = state.authenticatedUser.uid;

                          state.userService
                              .saveUser(thisUser)
                              .then((bool userSaved) {
                            Navigator.of(context).pushReplacementNamed("/home");
                          });
                        }
                      });
                      // thisUser.id = uid;
                    });
                  } else {
                    state.showAlertDialog(
                        context: context,
                        title: "Oopsie",
                        description:
                            "Sorry ${state.getForm("registerForm").getFieldValue("firstname")}, please try again as something went wrong");
                  }
                });
              }
            });
          });
    }

    return Center(
      child: Container(
        color: Colors.transparent,
        margin: EdgeInsets.symmetric(vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _registerForm,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                // margin: EdgeInsets.all(10.00),
                decoration: BoxDecoration(image: _buildBackgroundImage()),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    child: ListView(
                      children: <Widget>[_buildRegisterOption(context, state)],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}
