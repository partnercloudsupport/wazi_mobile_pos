import 'package:flutter/material.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage"),
        centerTitle: true,
      ),
      drawer: MainDrawer(
        startingIndex: 6,
      ),
      body: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: DecoratedText(
              "Checkout Options",
              alignment: Alignment.center,
              fontSize: 18.0,
            ),
          ),
          ListTile(
            title: Text("Payment Types"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          ListTile(
            title: Text("Currencies"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Taxes"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Wallets"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: DecoratedText(
              "Device Permissions",
              alignment: Alignment.center,
              fontSize: 18.0,
            ),
          ),
          ListTile(
            title: Text("Contacts"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Camera"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Gallery"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Storage"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0),
            child: DecoratedText(
              "Other",
              alignment: Alignment.center,
              fontSize: 18.0,
            ),
          ),
          ListTile(
            title: Text("Folder Settings"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
          ListTile(
            title: Text("Get Help"),
            trailing: Icon(Icons.arrow_right),
            onTap: () {},
            //trailing: _buildTrailingWidget("5 Active", Icons.arrow_right),
          ),
          Divider(
            height: 2.0,
          ),
        ],
      ),
    );
  }
}
