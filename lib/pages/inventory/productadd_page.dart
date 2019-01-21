import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/inventory/product_item.dart';
import 'package:wazi_mobile_pos/services/system/firestoreobject_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wazi_mobile_pos/tools/filemanager.dart';

class ProductAddPage extends StatefulWidget {
  final AppState state;
  final List<Map<String, String>> categories;

  const ProductAddPage(
      {Key key, @required this.state, @required this.categories})
      : super(key: key);

  @override
  ProductAddPageState createState() {
    return new ProductAddPageState();
  }
}

class ProductAddPageState extends State<ProductAddPage> {
  int _currentStep;
  ProductItem _currentProduct;
  GlobalKey<FormState> _detailsForm = GlobalKey();
  File _pictureFile;
  FormAddState _currentState;

  @override
  void initState() {
    super.initState();
    this._currentStep = 0;
    this._currentProduct = ProductItem();
    this._currentState = FormAddState.create;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Product"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildStateBody(context),
    );
  }

  Widget _buildStateBody(BuildContext context) {
    switch (this._currentState) {
      case FormAddState.create:
        return _buildStepper(context);
      case FormAddState.saved:
        //_showSnackBar(context);
        return AnimatedContainer(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${_currentProduct.displayName} saved successfully!",
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
      case FormAddState.saving:
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
        title: Text("Product Information"),
        isActive: true,
        subtitle: Text("time to describe your product"),
        content: _buildClientDetails(context),
      ),
      Step(
        title: Text("Snap Time"),
        isActive: true,
        subtitle: Text("only you can snap the way you snap it"),
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
          case 1: //Take a selfie
            if (_pictureFile != null) {
              mayproceed = true;
            } else
              mayproceed = false;
            break;
        }

        if (mayproceed && _currentStep == 1) {
          print("about to save product..");
          _saveProduct().then((bool result) {
            if (result) {
              //now we need to save the picture...

              setState(() {
                _currentState = FormAddState.saved;
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

  Future<bool> _saveProduct() async {
    setState(() {
      _currentState = FormAddState.saving;
    });

    //we need to first save the profile picture in object storage
    FirestoreObjectService objectStorage = FirestoreObjectService();
    var uploadResult = await objectStorage.uploadFile(_pictureFile,
        folder: "products", category: "productimages");

    var uploadPath = await uploadResult.ref.getPath();

    var downloadUrl = await objectStorage.getDownloadUrl(fullpath: uploadPath);

    _currentProduct.images = [uploadPath, downloadUrl, _pictureFile.path];

    //we also need to write a file to local disc hey... no kidding

    var result = await widget.state.inventoryService
        .saveProduct(_currentProduct, widget.state);

    return result;
  }

  Widget _buildClientDetails(BuildContext context) {
    FocusNode node1 = FocusNode();
    FocusNode node2 = FocusNode();
    FocusNode node3 = FocusNode();
    FocusNode node4 = FocusNode();

    return Container(
        child: Form(
      key: _detailsForm,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Name *",
            ),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 35,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(node2);
            },
            onSaved: (String value) {
              _currentProduct.name = value;
              _currentProduct.displayName = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Product name is required";
            },
          ),
          TextFormField(
            focusNode: node2,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Description *",
            ),
            keyboardType: TextInputType.text,
            maxLength: 75,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(node3);
            },
            onSaved: (String value) {
              _currentProduct.description = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Please describe your product";
            },
          ),
          TextFormField(
            focusNode: node3,
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Selling price *",
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              // WhitelistingTextInputFormatter.digitsOnly,
              // CurrencyInputFormatter()
            ],
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onSaved: (String value) {
              _currentProduct.sellingprice = double.parse(value);
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Please enter the selling price";
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Category *",
            ),
            value: _currentProduct.categoryId,
            onSaved: (String value) {
              _currentProduct.categoryId = value;
            },
            onChanged: (String type) {
              setState(() {
                _currentProduct.categoryId = type;
              });
            },
            validator: (String value) {
              if (value == null || value.isEmpty) return "Category is required";
            },
            items: widget.categories.map((item) {
              return DropdownMenuItem(
                value: item["id"],
                child: Text(item["name"]),
              );
            }).toList(),
          )
        ],
      ),
    ));
  }

  Widget _buildAvatar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.state.fileManager
            .getCameraImage(compress: true, maxSizeKb: 1000)
            .then((picture) {
          if (picture != null) {
            print(picture.uri);
            setState(() {
              _pictureFile = picture;
            });
          }
        });
      },
      child: _pictureFile == null
          ? CircleAvatar(
              backgroundColor: Colors.pink,
              minRadius: 64.0,
              maxRadius: 136.0,
              child: Icon(
                Icons.image,
                size: 64.0,
                color: Colors.white,
              ),
            )
          : ClipOval(
              child: Image.file(
                _pictureFile,
                fit: BoxFit.cover,
                height: 120.0,
                width: 120.0,
              ),
            ),
    );
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
                      .getCameraImage(
                    compress: true,
                  )
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
                      .getGalleryImage(compress: true)
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

    var compressedImage =
        await FileManager().compressFile(file: picture, maxSizeKb: 200);

    return compressedImage;
  }

  void writeToFile(List<int> list, String filePath) {
    var file = File(filePath);
    file.writeAsBytes(list, flush: true, mode: FileMode.write);
  }
}

enum FormAddState { create, saving, saved }
