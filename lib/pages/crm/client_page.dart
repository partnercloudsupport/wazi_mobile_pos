import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/pages/crm/clientadd_page.dart';
import 'package:wazi_mobile_pos/pages/crm/clientview_page.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/core/main_drawer.dart';
import 'package:wazi_mobile_pos/widgets/crm/client_list.dart';

class ClientPage extends StatefulWidget {
  final AppState initialState;

  const ClientPage({Key key, this.initialState}) : super(key: key);

  @override
  ClientPageState createState() {
    return new ClientPageState();
  }
}

class ClientPageState extends State<ClientPage> {
  @override
  void initState() {
    super.initState();
    widget.initialState?.customerService?.loadCustomers(widget.initialState);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
                title: Text("Customers"),
                backgroundColor: Theme.of(context).primaryColor,
                elevation: 5.0,
                centerTitle: true,
                bottom: TabBar(
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(Icons.favorite),
                      text: "Favourites",
                    ),
                    Tab(
                      icon: Icon(Icons.recent_actors),
                      text: "All",
                    ),
                  ],
                )),
            drawer: MainDrawer(
              startingIndex: 3,
            ),
            body: TabBarView(
              // controller: context.widget.,
              children: <Widget>[
                _buildFavouritesList(context, state),
                _buildCustomerList(context, state)
              ],
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
          ),
        );
      },
    );
  }

  Widget _buildCustomerList(BuildContext context, AppState state) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('not started yet...');
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return new Text('it is active and loaded');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              if (snapshot.hasData) {
                // print("displaying customers...");
                return ClientList(
                  initialClients: snapshot.data,
                );
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: state.customerService.loadCustomers(state),
    );
  }

  Widget _buildFavouritesList(BuildContext context, AppState state) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return new Text('not started yet...');
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          case ConnectionState.active:
            return new Text('it is active and loaded');
          case ConnectionState.done:
            if (snapshot.hasError) {
              return new Text(
                '${snapshot.error}',
                style: TextStyle(color: Colors.red),
              );
            } else {
              if (snapshot.hasData) {
                // print("displaying customers...");
                return _buildFavoritesGrid(state, snapshot);
              } else {
                return new ListView(children: <Widget>[
                  new Text("sorry my friend you have no customers..")
                ]);
              }
            }
        }
      },
      future: state.customerService.getFavourites(state),
    );
  }

  Widget _buildFavoritesGrid(
      AppState state, AsyncSnapshot<List<Client>> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (BuildContext context, int index) {
        var c = snapshot.data[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => ClientViewPage(c, state),
              ),
            );
          },
          child: Card(
            elevation: 5.0,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: File(c.images[2]).existsSync()
                        ? FileImage(File(c.images[2]))
                        : NetworkImage(c.images[1]),
                    fit: BoxFit.cover),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "${c.displayName}${c.familyName}",
                    style: TextStyle(color: Colors.white, fontSize: 24.0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 360 ? 4 : 2),
    );
  }
}
