import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/services/system/firestore_service.dart';
import 'package:wazi_mobile_pos/services/system/localstrorage_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class CustomerService extends Model {
  AppState state;
  LocalStorageService _localStorageService;

  CustomerService(AppState state) {
    _localStorageService = LocalStorageService("wazimerchant:customers");
  }

  List<Client> _customers;
  List<Client> get customers {
    return List.from(_customers);
  }

  Future<bool> saveCustomer(Client customer) async {
    if (null != customer) {
      await FireStoreService().writeObject(
          collectionName: "customers",
          item: customer.toJson(),
          merge: false,
          timeout: 5);

      //need to actually wrtite the entire client listing out
      await _localStorageService.writeObject(customer.toJson());

      return true;
    }
    return false;
  }

  // Future<MerchantModel> setActiveMerchant(UserModel user) async {
  //   if (null != user) {
  //     var result = await FireStoreService().getObject(
  //         "merchants", {"field": "id", "value": "${user.merchantId}"});

  //     if (result != null) {
  //       var thisMerchant = MerchantModel.fromJson(result);
  //       this._activeMerchant = thisMerchant;
  //       await _localStorageService.writeObject(thisMerchant.toJson());
  //       return _activeMerchant;
  //     } else
  //       return null;
  //   }
  //   return null;
  // }

  // Future<MerchantModel> getActiveMerchant() async {
  //   if (this._activeMerchant != null) return this._activeMerchant;

  //   //it is null, so we must look in local storage first to see if there is anything...
  //   var storageResult = await _localStorageService.getObject();
  //   if (null != storageResult) {
  //     //we load from storage result
  //     var storedMerchant =
  //         MerchantModel.fromJson((storageResult as Map<String, dynamic>));
  //     this._activeMerchant = storedMerchant;
  //     return this._activeMerchant;
  //   }
  //   return null;
  // }
}
