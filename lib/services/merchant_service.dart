import 'package:firebase_auth/firebase_auth.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/models/merchant/merchant.dart';
import 'package:wazi_mobile_pos/models/user.dart';

mixin MerchantService on ServiceBase {
  Merchant _activeMerchant = null;

  Merchant get activeMerchant {
    if (this._activeMerchant == null)
      this._activeMerchant = Merchant(
          id: "abc132",
          merchantCode: "A0000001",
          contactDetails: "+2783 265 1709",
          location: "Daresalaam",
          name: "Hussein's Fine Art",
          operatingHours: "08:00 - 20:00",
          primaryBusiness: "African Art",
          storeImage: "assets/storeimage.jpg",
          tags: ["street merchant", "art", "fine art", "african art"],
          description: "The most beautiful art in all of Africa!");

    return this._activeMerchant;
  }

  void setMerchantInfo(FirebaseUser authenticatedUser) {
    this._activeMerchant = Merchant(
        id: "abc132",
        merchantCode: "A0000001",
        contactDetails: "+2783 265 1709",
        location: "Daresalaam",
        name: "Hussein's Fine Art",
        operatingHours: "08:00 - 20:00",
        primaryBusiness: "African Art",
        storeImage: "assets/storeimage.jpg",
        tags: ["street merchant", "art", "fine art", "african art"],
        description: "The most beautiful art in all of Africa!");
  }
}
