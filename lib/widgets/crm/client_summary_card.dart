import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/services/crm/client_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class ClientSummaryCard extends StatefulWidget {
  @override
  ClientSummaryCardState createState() {
    return new ClientSummaryCardState();
  }
}

class ClientSummaryCardState extends State<ClientSummaryCard> {
  Widget _buildClientsWidget(BuildContext context, AppState state) {

//
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          children: <Widget>[
            DecoratedText(
              "${state.clients == null ? "0" : state.clients.length.toString()} Customers",
              alignment: Alignment.center,
              fontSize: 18.0,
            ),
            DecoratedText(
              "refresh or navigate to the customers page to view options",
              alignment: Alignment.center,
              fontSize: 12.0,
            )
          ],
        )
      ],
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
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                DecoratedText(
                  "Client Summary",
                  alignment: Alignment.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16.0, 16.0, 0),
                    child: _buildClientsWidget(context, state),
                  ),
                ),
                ButtonTheme.bar(
                  child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        splashColor: Theme.of(context).accentColor,
                        child: Text(
                          "View",
                          semanticsLabel: "View ${state.activeMerchant.name}",
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        splashColor: Theme.of(context).accentColor,
                        child: Text(
                          "Add",
                          semanticsLabel: "Add ${state.activeMerchant.name}",
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        color: Theme.of(context).accentColor,
                        textColor: Colors.white,
                        splashColor: Theme.of(context).accentColor,
                        child: Text(
                          "Refresh",
                          semanticsLabel: "Add ${state.activeMerchant.name}",
                        ),
                        onPressed: () {
                          state.refreshClients();
                          state.refreshContacts();
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}
