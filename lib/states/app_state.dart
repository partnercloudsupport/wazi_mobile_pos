import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/services/checkout/transaction_service.dart';
import 'package:wazi_mobile_pos/services/inventory/inventory_service.dart';
import 'package:wazi_mobile_pos/services/authentication_service.dart';
import 'package:wazi_mobile_pos/services/system/customer_service.dart';
import 'package:wazi_mobile_pos/services/system/merchant_service.dart';
import 'package:wazi_mobile_pos/services/system/user_service.dart';
import 'package:wazi_mobile_pos/tools/filemanager.dart';
import 'package:wazi_mobile_pos/widgets/general/generic_form.dart';
import 'package:wazi_mobile_pos/services/checkout/shopping_cart_service.dart';

class AppState extends Model
    with ServiceBase, ShoppingCartService, AuthenticationService {
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

  InventoryService _inventoryService;

  InventoryService get inventoryService {
    if (null == _inventoryService) _inventoryService = InventoryService(this);

    return _inventoryService;
  }

  FileManager _fileManager;

  FileManager get fileManager {
    if (null == _fileManager) _fileManager = FileManager();
    return _fileManager;
  }

  TransactionService _transactionService;

  TransactionService get transactionService {
    if (null == _transactionService) _transactionService = TransactionService();

    return _transactionService;
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
