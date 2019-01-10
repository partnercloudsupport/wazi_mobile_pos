import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/models/trade/target.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class TargetService extends Model with ServiceBase {
  AppState appState;

  TargetService({@required this.appState});

  Target getTarget(TargetType type) {
    return Target(id: "abc12345", targetAmount: 500000.00, type: type, currency: "TZS ");
  }
}
