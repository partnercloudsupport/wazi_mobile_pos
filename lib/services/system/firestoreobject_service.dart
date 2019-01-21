import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

class FirestoreObjectService extends Model {
  FirebaseStorage _storage = FirebaseStorage();

  Future<StorageTaskSnapshot> uploadFile(File file,
      {@required String folder, @required String category}) async {
    if (file != null) {
      StorageReference filereference =
          _storage.ref().child(folder).child(category).child(Uuid().v4());

      var uploadTask = filereference.putFile(
          file,
          StorageMetadata(
              contentLanguage: "en",
              customMetadata: <String, String>{"activity": "test"}));

      return await uploadTask.onComplete;
    }

    return null;
  }

  Future<String> getDownloadUrl({@required fullpath}) async {
    StorageReference filereference = _storage.ref().child(fullpath);

    String downloadUrl = (await filereference.getDownloadURL()).toString();

    return downloadUrl;
  }
}
