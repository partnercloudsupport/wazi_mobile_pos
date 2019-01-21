import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:wazi_mobile_pos/models/checkout/cart_item.dart';
import 'package:wazi_mobile_pos/models/checkout/transaction_item.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/services/system/firestore_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class TransactionService {
  Future<bool> submitTransaction(List<CartItem> items, AppState state,
      {@required PaymentMethod paymentMethod, Client client}) async {
    if (null != items && items.length > 0) {
      var transactionId = Uuid().v4();

      var transaction = TransactionItem(
          id: transactionId, itemCount: items.length, amount: 0);

      var merchant = await state.merchantService.getActiveMerchant(state);
      var user = await state.userService.getActiveUser(state);

      transaction.merchantId = merchant.id;
      transaction.userId = user.userId;
      transaction.paymentMethod = paymentMethod;
      transaction.transactionDate = DateTime.now().toUtc();
      items.forEach((i) {
        transaction.amount += i.amount;
        i.transactionId = transactionId;
        i.merchantId = transaction.merchantId;
        i.userId = transaction.userId;
      });

      var docId = await FireStoreService().writeObject(
          collectionName: "transactions",
          item: transaction.toJson(),
          merge: false,
          timeout: 5);

      transaction.documentId = docId;

      items.forEach((i) {
        FireStoreService()
            .writeObject(
                collectionName: "cart_items",
                item: i.toJson(),
                merge: false,
                timeout: 5)
            .then((docId) {
          i.documentId = i.documentId;
        });
      });

      return true;
    }
    return false;
  }
}
