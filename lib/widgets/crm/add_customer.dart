import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class AddCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                DecoratedText(
                  "Customers are important",
                  alignment: Alignment.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
                DecoratedText(
                  "how about we add one?",
                  alignment: Alignment.center,
                  fontSize: 16.0,
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
                          "Add Contact",
                        ),
                        onPressed: () {},
                      ),
                      FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        splashColor: Theme.of(context).accentColor,
                        child: Text(
                          "Import Contacts",
                        ),
                        onPressed: () {
                          state.setContacts(autoAdd: true);
                          state.addContacts(state.contacts);
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
