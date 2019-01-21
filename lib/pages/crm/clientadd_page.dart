import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/services/system/firestoreobject_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:image_picker/image_picker.dart';
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
        title: Text("New Customer"),
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
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${_currentClient.displayName} saved successfully!",
                style: TextStyle(fontSize: 36.0),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 16.0,
              ),
              Text(
                "please tap on the circle to continue",
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(
                height: 8.0,
              ),
              CircleAvatar(
                minRadius: 64.0,
                backgroundColor: Theme.of(context).primaryColor,
                child: IconButton(
                  icon: Icon(Icons.check),
                  iconSize: 64.0,
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  splashColor: Theme.of(context).accentColor,
                ),
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

  void _showSnackBar(BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text("Saved successfully"),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: "Ok",
          onPressed: () {},
        ),
      ),
    );
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
            if (_pictureFile != null) {
              mayproceed = true;
            } else
              mayproceed = false;
            break;
        }

        if (mayproceed && _currentStep == 2) {
          //now we will save the customer to the firestore and to local storage just because we can....
          print("about to save customer..");
          _saveCustomer().then((bool result) {
            if (result) {
              //now we need to save the picture...

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

    //we need to first save the profile picture in object storage
    FirestoreObjectService objectStorage = FirestoreObjectService();
    var uploadResult = await objectStorage.uploadFile(_pictureFile,
        folder: "customers", category: "profilepictures");

    var uploadPath = await uploadResult.ref.getPath();

    var downloadUrl = await objectStorage.getDownloadUrl(fullpath: uploadPath);

    _currentClient.images = [uploadPath, downloadUrl, _pictureFile.path];

    //we also need to write a file to local disc hey... no kidding

    var result = await widget.state.customerService
        .saveCustomer(_currentClient, widget.state);

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
                  widget.state.fileManager
                      .getCameraImage(compress: true, maxSizeKb: 1250.0)
                      .then((picture) {
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
                  widget.state.fileManager
                      .getGalleryImage(compress: true, maxSizeKb: 1250.0)
                      .then((picture) {
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
