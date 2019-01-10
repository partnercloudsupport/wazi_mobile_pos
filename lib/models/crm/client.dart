import 'dart:typed_data';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';

class Client {
  Client(
      {this.givenName,
      this.middleName,
      this.prefix,
      this.suffix,
      this.familyName,
      this.company,
      this.jobTitle,
      this.emails,
      this.phones,
      this.avatar,
      this.iconData});

  String identifier,
      displayName,
      givenName,
      middleName,
      prefix,
      suffix,
      familyName,
      company,
      jobTitle;

  Iterable<ItemValue> emails = [];
  Iterable<ItemValue> phones = [];
  Uint8List avatar;
  IconData iconData;

  Client.fromMap(Map m) {
    identifier = m["identifier"];
    displayName = m["displayName"];
    givenName = m["givenName"];
    middleName = m["middleName"];
    familyName = m["familyName"];
    prefix = m["prefix"];
    suffix = m["suffix"];
    company = m["company"];
    jobTitle = m["jobTitle"];
    emails = (m["emails"] as Iterable)?.map((m) => ItemValue.fromMap(m));
    phones = (m["phones"] as Iterable)?.map((m) => ItemValue.fromMap(m));

    avatar = m["avatar"];
    iconData = Icons.verified_user;
  }

  Client.fromContact(Contact c) {
    identifier = c.identifier;
    displayName = c.displayName;
    givenName = c.givenName;
    middleName = c.middleName;
    familyName = c.familyName;
    prefix = c.prefix;
    suffix = c.suffix;
    company = c.company;
    jobTitle = c.jobTitle;
    avatar = c.avatar;
    iconData = Icons.verified_user;
  }

  static Map _toMap(Client contact) {
    var emails = [];
    for (ItemValue email in contact.emails ?? []) {
      emails.add(ItemValue._toMap(email));
    }
    var phones = [];
    for (ItemValue phone in contact.phones ?? []) {
      phones.add(ItemValue._toMap(phone));
    }

    return {
      "identifier": contact.identifier,
      "displayName": contact.displayName,
      "givenName": contact.givenName,
      "middleName": contact.middleName,
      "familyName": contact.familyName,
      "prefix": contact.prefix,
      "suffix": contact.suffix,
      "company": contact.company,
      "jobTitle": contact.jobTitle,
      "emails": emails,
      "phones": phones,
      "avatar": contact.avatar
    };
  }
}

/// Item class used for contact fields which only have a [label] and
/// a [value], such as emails and phone numbers
class ItemValue {
  ItemValue({this.label, this.value});
  String label, value;

  ItemValue.fromMap(Map m) {
    label = m["label"];
    value = m["value"];
  }

  static Map _toMap(ItemValue i) => {"label": i.label, "value": i.value};
}
