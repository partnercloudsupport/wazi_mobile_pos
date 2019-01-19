import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/models/crm/item_value.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class ClientAddPage extends StatefulWidget {
  final AppState state;

  const ClientAddPage({Key key, @required this.state}) : super(key: key);

  @override
  ClientAddPageState createState() {
    return new ClientAddPageState();
  }
}

class ClientAddPageState extends State<ClientAddPage> {
  int _currentStep;
  Client _currentClient;
  GlobalKey<FormState> _contactForm = GlobalKey();
  GlobalKey<FormState> _detailsForm = GlobalKey();
  File _pictureFile;
  CustomerAddState _currentState;

  @override
  void initState() {
    super.initState();
    this._currentStep = 0;
    this._currentClient = Client();
    this._currentState = CustomerAddState.create;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      
      body: _buildStateBody(context),
    );
  }

  Widget _buildStateBody(BuildContext context) {
    switch (this._currentState) {
      case CustomerAddState.create:
        return _buildStepper(context);
      case CustomerAddState.saved:
        return AnimatedContainer(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width * 0.8,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12.0),
          ),
          margin: EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              DecoratedText(
                "Congratulations!",
                textColor: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                fontSize: 36.0,
              ),
              DecoratedText(
                "${_currentClient.givenName} has been saved succesfully",
                textColor: Theme.of(context).primaryColor,
                alignment: Alignment.center,
                fontSize: 24.0,
              ),
              RaisedButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
          duration: Duration(seconds: 3),
        );
        break;
      case CustomerAddState.saving:
        return Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        );
        break;
    }

    return null;
  }

  Widget _buildStepper(BuildContext context) {
    List<Step> steps = [
      Step(
        title: Text("Client Information"),
        isActive: true,
        subtitle: Text("let's get to know your new customer"),
        content: _buildClientDetails(context),
      ),
      Step(
        title: Text("Contact Details"),
        isActive: true,
        subtitle: Text("time to make a contact"),
        content: _buildContactDetailsForm(context),
      ),
      Step(
        title: Text("Snap Time"),
        isActive: true,
        subtitle: Text("take a photo of your customer"),
        content: _buildCustomerSnapControl(context),
      )
    ];

    return Stepper(
      currentStep: _currentStep,
      steps: steps,
      type: StepperType.vertical,
      onStepCancel: () {
        setState(() {
          _currentStep--;
        });
      },
      onStepContinue: () {
        //we need to validate first.
        bool mayproceed;

        switch (_currentStep) {
          case 0: //Client Information
            setState(() {
              if (_detailsForm.currentState.validate()) {
                _detailsForm.currentState.save();
                mayproceed = true;
              }
            });
            break;
          case 1: //Contact Details
            if (_contactForm.currentState.validate()) {
              _contactForm.currentState.save();
              mayproceed = true;
            }
            break;
          case 2: //Take a selfie
            if (_pictureFile != null)
              mayproceed = true;
            else
              mayproceed = false;
            break;
        }

        if (mayproceed && _currentStep == 2) {
          //now we will save the customer to the firestore and to local storage just because we can....
          print("about to save customer..");
          _saveCustomer().then((bool result) {
            if (result) {
              setState(() {
                _currentState = CustomerAddState.saved;
              });
            }
          });
        } else {
          if (mayproceed)
            setState(() {
              _currentStep++;
            });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          if (index < _currentStep) _currentStep = index;
        });
      },
    );
  }

  Future<bool> _saveCustomer() async {
    setState(() {
      _currentState = CustomerAddState.saving;
    });

    var result =
        await widget.state.customerService.saveCustomer(_currentClient);

    return result;
  }

  Widget _buildClientDetails(BuildContext context) {
    FocusNode node1 = FocusNode();
    FocusNode node2 = FocusNode();

    return Container(
        child: Form(
      key: _detailsForm,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Firstname *",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 20,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(node2);
            },
            onSaved: (String value) {
              _currentClient.givenName = value;
              _currentClient.displayName = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Firstname is required";
            },
          ),
          TextFormField(
            focusNode: node2,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Lastname *",
            ),
            keyboardType: TextInputType.text,
            maxLength: 20,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              if (_detailsForm.currentState.validate()) {
                _detailsForm.currentState.save();
                setState(() {
                  _currentStep++;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            onSaved: (String value) {
              _currentClient.familyName = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Last name is required";
            },
          ),
        ],
      ),
    ));
  }

  Widget _buildContactDetailsForm(BuildContext context) {
    FocusNode node1 = FocusNode();
    FocusNode node2 = FocusNode();

    return Container(
        child: Form(
      key: _contactForm,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Mobile Number *",
            ),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            maxLength: 20,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(node2);
            },
            onSaved: (String value) {
              _currentClient.phones = [value];
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Mobile number is required, please enter a mobile number";
            },
          ),
          TextFormField(
            focusNode: node2,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Email Address",
            ),
            keyboardType: TextInputType.emailAddress,
            maxLength: 20,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              if (_contactForm.currentState.validate()) {
                _contactForm.currentState.save();
                setState(() {
                  _currentStep++;
                });
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
            onSaved: (String value) {
              if (value != null || value.isNotEmpty)
                _currentClient.emails = [value];
            },
            validator: (String value) {},
          ),
        ],
      ),
    ));
  }

  Widget _buildAvatar(BuildContext context) {
    return Center(
      child: ClipOval(
        child: _pictureFile == null
            ? Image.asset(
                "assets/brandon.png",
                fit: BoxFit.cover,
                height: 120.0,
                width: 120.0,
              )
            : Image.file(
                _pictureFile,
                fit: BoxFit.cover,
                height: 120.0,
                width: 120.0,
              ),
      ),
    );

    //  child: CircleAvatar(
    //     backgroundImage: _pictureFile == null
    //         ? AssetImage("assets/brandon.png")
    //         : Image.file(_pictureFile),
    //     minRadius: 36.0,
    //     maxRadius: 72.0,
    //   ),
    // );
  }

  Widget _buildCustomerSnapControl(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Container(
          child: _buildAvatar(context),
          height: 120.0,
        ),
        SizedBox(
          height: 16.0,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                child: Text("Take Photo"),
                onPressed: () {
                  _openCamera().then((File picture) {
                    if (picture != null) {
                      print(picture.uri);
                      setState(() {
                        _pictureFile = picture;
                      });
                    }
                  });
                },
                color: Theme.of(context).accentColor,
                elevation: 5.0,
                textColor: Colors.white,
              ),
              flex: 5,
            ),
            SizedBox(
              width: 5.0,
            ),
            Expanded(
              child: RaisedButton(
                child: Text("Upload Photo"),
                onPressed: () {
                  _openGallery().then((File picture) {
                    if (picture != null) {
                      print(picture.uri);
                      setState(() {
                        _pictureFile = picture;
                      });
                    }
                  });
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                elevation: 5.0,
              ),
              flex: 5,
            )
          ],
        )
      ],
    ));
  }

  Future<File> _openCamera() async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );

    return picture;
  }

  Future<File> _openGallery() async {
    var picture = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );

    return picture;
  }
}

enum CustomerAddState { create, saving, saved }
