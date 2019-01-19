import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/enums.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/circle_logo.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';
import 'package:wazi_mobile_pos/widgets/crm/client_list.dart';
import 'package:wazi_mobile_pos/widgets/merchant/merchant_dashboard.dart';
import 'package:wazi_mobile_pos/widgets/trade/add_product.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _displayIndex = 0;
  String _currentView = "Home";
  GlobalKey<State> _homeKey = GlobalKey<State>();

  Widget _getBodyWidget(int index) {
    if (index == 0) {
      {
        return MerchantDashboard();
      }
    } else if (index == 1) {
      return ClientList();
    } else if (index == 2) {
      return AddProduct();
    }

    return Text("Index: ${index.toString()}");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget child, AppState state) {
      return Scaffold(
        key: _homeKey,
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text("Home"),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (UserOptions option) {
                switch (option) {
                  case UserOptions.SignOut:
                    state.signOut();

                    Navigator.of(context).pushReplacementNamed("/landing");
                    break;
                  case UserOptions.ViewProfile:
                    break;
                }
              },
              icon: Icon(Icons.person),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<UserOptions>>[
                    const PopupMenuItem<UserOptions>(
                      value: UserOptions.ViewProfile,
                      child: Text('View Profile'),
                    ),
                    const PopupMenuItem<UserOptions>(
                      value: UserOptions.SignOut,
                      child: Text('Sign Out'),
                    ),
                  ],
            )
          ],
          centerTitle: true,
        ),
        drawer: MainDrawer(
          startingIndex: 0,
        ),
        body: _getBodyWidget(_displayIndex),
      );
    });
  }
}
