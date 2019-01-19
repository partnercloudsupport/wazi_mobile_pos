import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/pages/crm/clientadd_page.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';

class ClientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Customers"),
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 5.0,
            centerTitle: true,
          ),
          drawer: MainDrawer(
            startingIndex: 3,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClientAddPage(
                        state: state,
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
