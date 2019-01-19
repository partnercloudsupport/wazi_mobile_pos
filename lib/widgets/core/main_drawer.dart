import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class MainDrawer extends StatefulWidget {
  final int startingIndex;

  const MainDrawer({Key key, @required this.startingIndex}) : super(key: key);

  @override
  MainDrawerState createState() {
    return new MainDrawerState();
  }
}

class MainDrawerState extends State<MainDrawer> {
  int _displayIndex;

  @override
  void initState() {
    super.initState();
    _displayIndex = widget.startingIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Drawer(
          elevation: 20.0,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(state.userService.activeUser.name),
                accountEmail: Text(state.userService.activeUser.email),
                currentAccountPicture: Image.asset("assets/brandon.png"),
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
              ListTile(
                leading: Icon(Icons.home,
                    color: _displayIndex == 0
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 0
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.local_convenience_store,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 0;
                  });
                  Navigator.pushReplacementNamed(context, "/home");
                },
                title: Text(
                  "Home",
                  style: TextStyle(
                      color: _displayIndex == 0
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.add_shopping_cart,
                    color: _displayIndex == 1
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 1
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.attach_money,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 1;
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  "Make Sale",
                  style: TextStyle(
                      color: _displayIndex == 1
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.view_list,
                    color: _displayIndex == 2
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 2
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.assignment,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 2;
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  "Manage Inventory",
                  style: TextStyle(
                      color: _displayIndex == 2
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.people,
                    color: _displayIndex == 3
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 3
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.import_contacts,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  //let us go to the customers page and start working....
                  Navigator.pushReplacementNamed(context, "/customers");
                },
                title: Text(
                  "View Customers",
                  style: TextStyle(
                      color: _displayIndex == 3
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.supervised_user_circle,
                    color: _displayIndex == 4
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 4
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.perm_identity,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 4;
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  "Manage Staff",
                  style: TextStyle(
                      color: _displayIndex == 4
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.insert_chart,
                    color: _displayIndex == 5
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 5
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.pie_chart,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 5;
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  "Reports",
                  style: TextStyle(
                      color: _displayIndex == 5
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
              ListTile(
                leading: Icon(Icons.settings,
                    color: _displayIndex == 6
                        ? Theme.of(context).accentColor
                        : Colors.black),
                trailing: _displayIndex != 6
                    ? Icon(Icons.arrow_right)
                    : Icon(
                        Icons.settings_applications,
                        color: Theme.of(context).accentColor,
                      ),
                onTap: () {
                  setState(() {
                    _displayIndex = 6;
                  });
                  Navigator.pop(context);
                },
                title: Text(
                  "Manage",
                  style: TextStyle(
                      color: _displayIndex == 6
                          ? Theme.of(context).accentColor
                          : Colors.black),
                ),
              ),
              Divider(height: 2.0),
            ],
          ),
        );
      },
    );
  }
}
