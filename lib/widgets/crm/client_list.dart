import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/crm/add_customer.dart';

class ClientList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ClientListState();
  }
}

class ClientListState extends State<ClientList> {
  @override
  initState() {
    super.initState();
  }

  Widget _buildClientList(BuildContext context, AppState state) {
    return Scaffold(
      body: state.clients != null
          ? ListView.builder(
              itemCount: state.clients?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                var c = state.clients?.elementAt(index);
                return ListTile(
                  leading: (c.avatar != null && c.avatar.length > 0)
                      ? CircleAvatar(backgroundImage: MemoryImage(c.avatar))
                      : CircleAvatar(
                          child: Text(c.displayName.length > 1
                              ? (c.displayName.isEmpty)
                                  ? ""
                                  : c.displayName.substring(0, 2).toUpperCase()
                              : "")),
                  title: Text(c.displayName ?? ""),
                  onTap: () {},
                  // trailing: Icon(c.iconData),
                );
              })
          : Center(child: AddCustomer()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Container(child: _buildClientList(context, state));
      },
    );
  }
}
