import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';
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
    if (null == _customers) _customers = [];
    return List.from(_customers);
  }

  Future<bool> saveCustomer(Client customer, AppState state) async {
    if (null != customer) {
      customer.identifier = Uuid().v4();
      var merchant = state.merchantService.activeMerchant;
      customer.merchantId = merchant?.id;
      customer.createDate = DateTime.now().toUtc();

      var docId = await FireStoreService().writeObject(
          collectionName: "customers",
          item: customer.toJson(),
          merge: false,
          timeout: 5);

      //set the documentId of the object
      customer.documentID = docId;

      _customers.add(customer);
      notifyListeners();

      //need to actually wrtite the entire client listing out
      //
      await _localStorageService.writeObject(customer.toJson());

      return true;
    }
    return false;
  }

  Future<bool> updateCustomer(Client customer, AppState state) async {
    if (null != customer) {
      await FireStoreService().writeObject(
          collectionName: "customers",
          id: customer.documentID,
          item: customer.toJson(),
          merge: true,
          timeout: 5);

      notifyListeners();

      return true;
    }
    return false;
  }

  Future<List<Client>> loadCustomers(AppState state) async {
    if (state != null) {
      if (this._customers != null && this._customers.length > 0)
        return this._customers;

      var activeMerchant = await state.merchantService.getActiveMerchant(state);

      var result = await FireStoreService().getObjects("customers",
          {"field": "merchantId", "value": "${activeMerchant.id}"});

      if (this._customers == null) _customers = [];

      if (this._customers.length > 0) return this.customers;

      if (result != null) {
        result.forEach((DocumentSnapshot doc) {
          print("adding customers");
          var thisCustomer = Client.fromJson(doc.data);
          thisCustomer.documentID = doc.documentID;
          this._customers.add(thisCustomer);
          print("added customer");
        });
      }
    }

    return this.customers;
  }

  Future<List<Client>> getFavourites(AppState state) async {
    if (state != null) {
      var clients = await loadCustomers(state);
      if (clients != null)
        return clients.where((Client c) => c.isFavorite == true).toList();
      return [];
    }

    return [];
  }

  Future<List<Client>> getRecents(AppState state) async {
    if (state != null) {
      var clients = await loadCustomers(state);
      if (clients != null)
        return clients.where((Client c) => c.isFavorite == true).toList();
      return [];
    }

    return [];
  }
}
