import 'package:flutter/material.dart';

class Transaction {
  String id;
  String merchantId;
  String customerId;
  String description;
  DateTime transactionDate;
  double amount;
  String currencyCode;
  PaymentType paymentType;

  Transaction(
      {@required this.id,
      @required this.merchantId,
      @required this.customerId,
      @required this.description,
      @required this.transactionDate,
      @required this.amount,
      @required this.currencyCode,
      @required this.paymentType});
}

enum PaymentType { cash, mobilemoney, card, eft }
