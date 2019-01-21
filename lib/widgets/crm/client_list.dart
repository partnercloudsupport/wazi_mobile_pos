import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/crm/client.dart';
import 'package:wazi_mobile_pos/pages/crm/clientview_page.dart';

import 'package:wazi_mobile_pos/states/app_state.dart';

class ClientList extends StatefulWidget {
  final List<Client> initialClients;

  const ClientList({Key key, @required this.initialClients}) : super(key: key);

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
      body: ListView.builder(
          itemCount: widget.initialClients?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            var c = widget.initialClients?.elementAt(index);
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: File(c.images[2]).existsSync()
                    ? FileImage(File(c.images[2]))
                    : NetworkImage(c.images[1]),
              ),
              title: Text("${c.displayName} ${c.familyName}"),
              subtitle: (c.phones != null && c.phones.length > 0)
                  ? Text(c.phones[0])
                  : null,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ClientViewPage(c, state)));
              },
              trailing: CircleAvatar(
                child: Text(c.displayName.substring(0, 1).toUpperCase()),
              ),
            );
          }),
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
