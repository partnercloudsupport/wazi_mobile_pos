import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/merchant/merchant_model.dart';

import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';
import 'package:wazi_mobile_pos/widgets/general/long_text.dart';
import 'package:wazi_mobile_pos/widgets/general/text_tag.dart';

class MerchantTile extends StatelessWidget {
  static const double height = 368.0;

  Widget _getStoreDetails(AppState state, BuildContext context) {
    return FutureBuilder(
      future: state.merchantService.getActiveMerchant(),
      builder: (BuildContext context, AsyncSnapshot<MerchantModel> snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(children: <Widget>[
                DecoratedText(
                  state.merchantService.activeMerchant.name,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                TextTag(
                    displayText:
                        state.merchantService.activeMerchant.primaryBusiness)
              ]),
              LongText(state.merchantService.activeMerchant.description),
              DecoratedText(
                "Trading Hours : " +
                    state.merchantService.activeMerchant.operatingHours,
                alignment: Alignment.bottomRight,
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget child, AppState state) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          height: height,
          child: Card(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 184.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: state.merchantService.activeMerchant
                                    .storeImage ==
                                null
                            ? Text("Missing Image")
                            : Image.asset(
                                state.merchantService.activeMerchant.storeImage,
                                fit: BoxFit.cover,
                              ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16.0, 16.0, 0),
                    child: _getStoreDetails(state, context),
                  ),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        splashColor: Theme.of(context).accentColor,
                        child: Text(
                          "VIEW",
                          semanticsLabel:
                              "View ${state.merchantService.activeMerchant.name}",
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
                bottomLeft: Radius.circular(2.0),
                bottomRight: Radius.circular(2.0),
              ),
            ),
          ),
        ),
      );
    });
  }
}
