import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/circle_logo.dart';
import 'package:wazi_mobile_pos/widgets/crm/client_list.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';
import 'package:wazi_mobile_pos/widgets/merchant/merchant_dashboard.dart';
import 'package:wazi_mobile_pos/widgets/trade/add_product.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;
  String _currentView = "Home";
  GlobalKey<State> _homeKey = GlobalKey<State>();

  Widget _getBodyWidget(int index) {
    if (index == 0) {
      {
        setState(() {
          this._currentView = "Home";
        });

        return MerchantDashboard();
      }
    } else if (index == 1) {
      setState(() {
        this._currentView = "Customers";
      });

      return ClientList();
    } else if (index == 2) {
      setState(() {
        this._currentView = "Trade";
      });

      return AddProduct();
    }

    return Text("Index: ${index.toString()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _homeKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: GestureDetector(
            child: CircleLogo(
              image: "assets/lf_logo.png",
              isTransparent: true,
            ),
            onTap: () {}),
        title: Text(_currentView),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          )
        ],
        centerTitle: true,
      ),
      body: _getBodyWidget(_bottomNavIndex),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: (int index) {
            setState(() {
              _bottomNavIndex = index;

              //Navigator.pushReplacementNamed(context, '/login');
            });
          },
          currentIndex: _bottomNavIndex,
          fixedColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.people,
                  size: 28.0,
                ),
                title: Text("Customers")),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart), title: Text("Trade")),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), title: Text("Manage")),
          ]),
    );
  }
}
