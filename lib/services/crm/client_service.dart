import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:simple_permissions/simple_permissions.dart';

import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

mixin ClientService on ServiceBase {
  AppState appState;

  PermissionStatus readStatus;
  PermissionStatus writeStatus;

  List<Client> _clients;
  Iterable<Contact> _contacts;
  bool _isBusy;

  bool get canRead {
    return this.readStatus == PermissionStatus.authorized;
  }

  bool get isBusy {
    return _isBusy;
  }

  bool get canWrite {
    return this.writeStatus == PermissionStatus.authorized;
  }

  Iterable<Client> get clients {
    return _clients;
  }

  Iterable<Contact> get contacts {
    print(_contacts);
    return _contacts;
  }

  void refreshContacts() {
    print(
        "can read: ${this.canRead.toString()} : ${this.readStatus.toString()}");
    this._contacts = null;
    setContacts();
  }

  void refreshClients() {
    print("refresh clients()");
  }

  void addContacts(Iterable<Contact> contacts) {
    if (contacts != null) {
      if (_clients == null) _clients = [];
      this._isBusy = true;
      notifyListeners();
      for (int i = 0; i <= contacts.length; i++) {
        try {
          _clients.add(Client.fromContact(contacts.elementAt(i)));
        } catch (Exception) {}
      }
      print('return loadFromContacts()');
    }
    this._isBusy = false;
    notifyListeners();
  }

  Future<Iterable<Contact>> getContacts() async {
    print('start getContacts()');
    if (this.canRead) {
      print("pulling contacts from phone!");
      return await ContactsService.getContacts();
    }
    return null;
  }

  void setPermissionStatuses() {
    print("set permission status start()");

    SimplePermissions.getPermissionStatus(Permission.ReadContacts)
        .then((PermissionStatus value) {
      this.readStatus = value;
      print(this.readStatus);
      notifyListeners();
    });

    SimplePermissions.getPermissionStatus(Permission.WriteContacts)
        .then((PermissionStatus value) {
      this.writeStatus = value;
      print(this.writeStatus);
      notifyListeners();
    });

    print("set permission status end()");
  }

  void requestReadAccess() async {
    if (!this.canRead) {
      this.readStatus =
          await SimplePermissions.requestPermission(Permission.ReadContacts);
      print(this.readStatus);
      // print("requesing read access");
      // SimplePermissions.requestPermission(Permission.ReadContacts)
      //     .then((PermissionStatus value) {
      //   this.readStatus = value;
      //   notifyListeners();
      // });
    }
  }

  void requestWriteAccess() async {
    this.writeStatus =
        await SimplePermissions.requestPermission(Permission.WriteContacts);
  }

  void setContacts({bool autoAdd = false}) async {
    print('start setContacts()');

    if (autoAdd && this.contacts != null && this.contacts.length > 0) {
      this.addContacts(this.contacts);
      notifyListeners();
      return;
    }

    this.setPermissionStatuses();
    this.requestReadAccess();
    print('setContacts() : getContacts starting');
    await this.getContacts().then((Iterable<Contact> value) {
      print('setContacts() : getContacts called');
      this._contacts = value;
      print(value);
      notifyListeners();
    });
  }
}
