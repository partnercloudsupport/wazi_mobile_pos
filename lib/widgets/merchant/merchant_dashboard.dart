import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/crm/client_summary_card.dart';
import 'package:wazi_mobile_pos/widgets/merchant/merchant_tile.dart';
import 'package:wazi_mobile_pos/widgets/trade/target_card.dart';

class MerchantDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState model) {
        return Container(
          color: Color.fromRGBO(237, 237, 237, 1.0),
          child: ListView(
            children: <Widget>[
              MerchantTile(),
              TargetCard(),
              ClientSummaryCard(),
              Container(
                margin: EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: FloatingActionButton(
                  child: Icon(Icons.add),
                  tooltip: "Add more cards",
                  onPressed: () {},
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
