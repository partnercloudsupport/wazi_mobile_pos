import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';

import 'package:wazi_mobile_pos/services/product_service.dart';
import 'package:wazi_mobile_pos/services/authentication_service.dart';
import 'package:wazi_mobile_pos/services/crm/client_service.dart';
import 'package:wazi_mobile_pos/services/system/customer_service.dart';
import 'package:wazi_mobile_pos/services/system/merchant_service.dart';
import 'package:wazi_mobile_pos/services/system/user_service.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';

class AppState extends Model
    with ServiceBase, ProductService, AuthenticationService, ClientService {
  UserService _userService;
  UserService get userService {
    if (null == _userService) _userService = UserService(this);

    return _userService;
  }

  MerchantService _merchantService;

  MerchantService get merchantService {
    if (null == _merchantService) _merchantService = MerchantService(this);

    return _merchantService;
  }

  CustomerService _customerService;

  CustomerService get customerService {
    if (null == _customerService) _customerService = CustomerService(this);

    return _customerService;
  }

  List<FormModel> forms;

  void registerForm(FormModel formModel) {
    if (null == this.forms) this.forms = [];

    //remove any previous form models
    if (this.forms.any((FormModel model) => model.key == formModel.key)) {
      this.forms.removeWhere((FormModel model) => model.key == formModel.key);
    }

    this.forms.add(formModel);
  }

  FormModel getForm(String key) {
    if (null == this.forms) return null;
    return this.forms.firstWhere((FormModel o) => o.key == key);
  }

  void initialize() {
    print("appState: initialize()");
    if (this.authenticatedUser == null) return;

    //load all async datasets
    //this.setContacts();@required
    print("appState: initialize() end");
  }

  void showAlertDialog(
      {@required BuildContext context,
      @required String title,
      @required String description,
      Function onPressed}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
          );
        });
  }
}
