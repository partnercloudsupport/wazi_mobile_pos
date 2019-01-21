import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/inventory/product_category.dart';
import 'package:wazi_mobile_pos/models/inventory/product_item.dart';
import 'package:wazi_mobile_pos/services/system/firestore_service.dart';
import 'package:wazi_mobile_pos/services/system/localstrorage_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class InventoryService extends Model {
  AppState state;
  LocalStorageService _localStorageService;

  InventoryService(AppState state) {
    _localStorageService = LocalStorageService("wazimerchant:customers");
  }

  List<ProductCategory> _categories;
  List<ProductCategory> get categories {
    if (null == _categories) _categories = [];
    return List.from(_categories);
  }

  List<ProductItem> _products;
  List<ProductItem> get products {
    if (null == _products) _products = [];
    return List.from(_products);
  }

  Future<bool> saveCategory(ProductCategory category, AppState state) async {
    if (null != category) {
      category.id = Uuid().v4();
      category.createDate = DateTime.now().toUtc();

      var docId = await FireStoreService().writeObject(
          collectionName: "product_categories",
          item: category.toJson(),
          merge: false,
          timeout: 5);

      //set the documentId of the object
      category.documentId = docId;

      _categories.add(category);
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> updateCategory(ProductCategory category, AppState state) async {
    if (null != category) {
      await FireStoreService().writeObject(
          collectionName: "product_categories",
          id: category.documentId,
          item: category.toJson(),
          merge: true,
          timeout: 5);

      notifyListeners();
  
      return true;
    }
    return false;
  }

  Future<List<ProductCategory>> loadCategories(AppState state) async {
    if (state != null) {
      if (this._categories != null && this._categories.length > 0)
        return this._categories;

      var result = await FireStoreService().getAllObjects("product_categories");

      if (this._categories == null) _categories = [];

      if (this._categories.length > 0) return this._categories;

      if (result != null) {
        result.forEach((DocumentSnapshot doc) {
          print("adding category");
          var category = ProductCategory.fromJson(doc.data);
          category.documentId = doc.documentID;
          this._categories.add(category);
          print("added category");
        });
      }
    }

    return this.categories;
  }

  Future<bool> saveProduct(ProductItem product, AppState state) async {
    if (null != product) {
      product.id = Uuid().v4();
      product.createDate = DateTime.now().toUtc();

      var merchant = await state.merchantService.getActiveMerchant(state);

      product.merchantId = merchant.id;

      var docId = await FireStoreService().writeObject(
          collectionName: "products",
          item: product.toJson(),
          merge: false,
          timeout: 5);

      //set the documentId of the object
      product.documentId = docId;

      _products.add(product);
      notifyListeners();

      return true;
    }
    return false;
  }

  Future<bool> updateProduct(ProductItem product, AppState state) async {
    if (null != product) {
      await FireStoreService().writeObject(
          collectionName: "products",
          id: product.documentId,
          item: product.toJson(),
          merge: true,
          timeout: 5);

      notifyListeners();

      return true;
    }
    return false;
  }

  Future<List<ProductItem>> loadProducts(AppState state) async {
    if (state != null) {
      var activeMerchant = await state.merchantService.getActiveMerchant(state);

      var result = await FireStoreService().getObjects(
          "products", {"field": "merchantId", "value": "${activeMerchant.id}"});

      if (this._products == null) _products = [];

      if (this._products.length > 0) return this._products;

      if (result != null) {
        result.forEach((DocumentSnapshot doc) {
          print("adding products");
          var product = ProductItem.fromJson(doc.data);
          product.documentId = doc.documentID;
          this._products.add(product);
          print("added product");
        });
      }
    }

    return this.products;
  }

  Future<List<ProductItem>> getProductsByCategory(
      AppState state, String categoryId) async {
    if (state != null) {
      var availableProducts = await loadProducts(state);
      if (null == availableProducts) {
        return [];
      }

      return availableProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    }

    return [];
  }
}
