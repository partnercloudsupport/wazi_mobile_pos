import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';

import 'package:wazi_mobile_pos/services/product_service.dart';
import 'package:wazi_mobile_pos/services/authentication_service.dart';
import 'package:wazi_mobile_pos/services/merchant_service.dart';
import 'package:wazi_mobile_pos/services/crm/client_service.dart';

class AppState extends Model
    with
        ServiceBase,
        ProductService,
        AuthenticationService,
        MerchantService,
        ClientService {
  void initialize() {
    print("appState: initialize()");
    if (this.authenticatedUser == null) return;

    //load all async datasets
    //this.setContacts();
    print("appState: initialize() end");
  }
}
