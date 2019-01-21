import 'dart:io';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/inventory/product_category.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class CategoryAddPage extends StatefulWidget {
  final AppState state;

  const CategoryAddPage({Key key, @required this.state}) : super(key: key);

  @override
  CategoryAddPageState createState() {
    return new CategoryAddPageState();
  }
}

class CategoryAddPageState extends State<CategoryAddPage> {
  int _currentStep;
  ProductCategory _category;
  GlobalKey<FormState> _categoryForm = GlobalKey();
  File _pictureFile;
  CategoryAddState _currentState;

  @override
  void initState() {
    super.initState();
    this._currentStep = 0;
    this._category = ProductCategory();
    this._currentState = CategoryAddState.create;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Category"),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _buildStateBody(context),
    );
  }

  Widget _buildStateBody(BuildContext context) {
    switch (this._currentState) {
      case CategoryAddState.create:
        return _buildStepper(context);
      case CategoryAddState.saved:
        //_showSnackBar(context);
        return AnimatedContainer(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "${_category.name} saved successfully!",
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
      case CategoryAddState.saving:
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
        title: Text("Enter Category"),
        isActive: true,
        subtitle: Text("describe your category"),
        content: _buildCategoryDetails(context),
      ),
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
              if (_categoryForm.currentState.validate()) {
                _categoryForm.currentState.save();
                mayproceed = true;
              }
            });
            break;
        }

        if (mayproceed && _currentStep == 0) {
          _saveCategory().then((bool result) {
            if (result) {
              setState(() {
                _currentState = CategoryAddState.saved;
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

  Future<bool> _saveCategory() async {
    setState(() {
      _currentState = CategoryAddState.saving;
    });

    _category.id = Uuid().v4();
    _category.createDate = DateTime.now().toUtc();

    var result = await widget.state.inventoryService
        .saveCategory(_category, widget.state);

    return result;
  }

  Widget _buildCategoryDetails(BuildContext context) {
    FocusNode node1 = FocusNode();
    FocusNode node2 = FocusNode();

    return Container(
        child: Form(
      key: _categoryForm,
      child: Column(
        children: <Widget>[
          TextFormField(
            focusNode: node1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(labelText: "Name *"),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            maxLength: 20,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              FocusScope.of(context).requestFocus(node2);
            },
            onSaved: (String value) {
              _category.name = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Category name is required";
            },
          ),
          TextFormField(
            focusNode: node2,
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              labelText: "Description *",
            ),
            keyboardType: TextInputType.text,
            maxLength: 150,
            onEditingComplete: () {},
            onFieldSubmitted: (String value) {
              if (_categoryForm.currentState.validate()) {
                _categoryForm.currentState.save();
              }
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onSaved: (String value) {
              _category.description = value;
            },
            validator: (String value) {
              if (value == null || value.isEmpty)
                return "Description is required";
            },
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Category type *",
            ),
            value: _category.type,
            onSaved: (dynamic value) {
              _category.type = value;
            },
            onChanged: (ProductCategoryType type) {
              setState(() {
                _category.type = type;
              });
            },
            validator: (dynamic value) {
              if (value == null) return "Category type is required";
            },
            items: ProductCategoryType.values.map((ProductCategoryType color) {
              return DropdownMenuItem(
                value: color,
                child: Text(color.toString().split(".")[1]),
              );
            }).toList(),
          ),
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: "Category color*",
            ),
            value: _category.color,
            onSaved: (dynamic value) {
              _category.color = value;
            },
            onChanged: (ProductCategoryColor value) {
              setState(() {
                _category.color = value;
              });
            },
            validator: (dynamic value) {
              if (value == null) return "Category color is required";
            },
            items:
                ProductCategoryColor.values.map((ProductCategoryColor color) {
              return DropdownMenuItem(
                value: color,
                child: Text(color.toString().split(".")[1]),
              );
            }).toList(),
          )
        ],
      ),
    ));
  }
}

enum CategoryAddState { create, saving, saved }
