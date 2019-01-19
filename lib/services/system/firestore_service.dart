import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FireStoreService {
  Firestore _store = Firestore.instance;

  Future<String> writeObject(
      {@required String collectionName,
      @required Map<String, dynamic> item,
      bool merge = false,
      String id,
      int timeout = 15}) async {
    String result;

    if (merge) {
      await _store
          .collection(collectionName)
          .document(id)
          .setData(item)
          .timeout(Duration(seconds: timeout))
          .catchError((Object e) {});
    } else {
      await _store
          .collection(collectionName)
          .add(item)
          .then((DocumentReference doc) {
            if (doc != null) {
              print("document saved hooray");
              result = doc.documentID;
            }
          })
          .timeout(Duration(seconds: timeout))
          .catchError((Object e) {});
    }

    return result;
  }

  Future<Map<String, dynamic>> getObject(
      String collectionName, Map<String, dynamic> criteria) async {
    QuerySnapshot queryResult = await _store
        .collection(collectionName)
        .where(criteria["field"], isEqualTo: criteria["value"])
        .getDocuments();
    List<DocumentSnapshot> docs = queryResult.documents;
    if (docs == null || docs.length == 0) return null;
    return docs.first.data;
  }
}

enum FireBaseOperator { EqualTo }
