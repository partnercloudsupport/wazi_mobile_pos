import 'package:scoped_model/scoped_model.dart';
import 'package:localstorage/localstorage.dart';

class LocalStorageService extends Model {
  final String key;

  LocalStorageService(this.key);

  Future<void> writeObject(Map<String, dynamic> data) async {
    LocalStorage storage = LocalStorage(this.key);
    await storage.ready.then((bool isReady) {
      if (!isReady) {
        print("Is not ready...");
      } else {
        storage.setItem(key, data);
      }
    });
  }

  Future<dynamic> getObject() async {
    LocalStorage storage = LocalStorage(key);
    await storage.ready.then((bool isReady) {
      if (!isReady) {
        return null;
      } else {
        return storage.getItem(key);
      }
    });
  }
}
