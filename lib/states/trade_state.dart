import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/service_base.dart';
import 'package:wazi_mobile_pos/services/trade/target_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';


class TradeState extends Model {

  TargetService _targetService;
  AppState appState;

  TradeState({@required this.appState});
  

  TargetService get targetService {
    if(this._targetService == null)
      this._targetService = TargetService(appState: appState);
    return this._targetService;
  }

 

}
