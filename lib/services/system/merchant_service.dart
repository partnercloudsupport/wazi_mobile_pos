import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/merchant/merchant_model.dart';
import 'package:wazi_mobile_pos/models/system/user_model.dart';
import 'package:wazi_mobile_pos/services/system/firestore_service.dart';
import 'package:wazi_mobile_pos/services/system/localstrorage_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class MerchantService extends Model {
  AppState state;
  LocalStorageService _localStorageService;

  MerchantService(AppState state) {
    _localStorageService = LocalStorageService("wazimerchant:merchantprofile");
  }

  //properties
  MerchantModel _activeMerchant;
  MerchantModel get activeMerchant {
    return _activeMerchant;
  }

  Future<bool> saveMerchant(MerchantModel merchant) async {
    if (null != merchant) {
      await FireStoreService().writeObject(
          collectionName: "merchants",
          item: merchant.toJson(),
          merge: false,
          timeout: 5);

      this._activeMerchant = merchant;
      await _localStorageService.writeObject(merchant.toJson());

      return true;
    }
    return false;
  }

  Future<MerchantModel> setActiveMerchant(UserModel user) async {
    if (null != user) {
      var result = await FireStoreService().getObject(
          "merchants", {"field": "id", "value": "${user.merchantId}"});

      if (result != null) {
        var thisMerchant = MerchantModel.fromJson(result);
        this._activeMerchant = thisMerchant;
        await _localStorageService.writeObject(thisMerchant.toJson());
        return _activeMerchant;
      } else
        return null;
    }
    return null;
  }

  Future<MerchantModel> getActiveMerchant() async {
    if (this._activeMerchant != null) return this._activeMerchant;

    //it is null, so we must look in local storage first to see if there is anything...
    var storageResult = await _localStorageService.getObject();
    if (null != storageResult) {
      //we load from storage result
      var storedMerchant =
          MerchantModel.fromJson((storageResult as Map<String, dynamic>));
      this._activeMerchant = storedMerchant;
      return this._activeMerchant;
    }
    return null;
  }
}
