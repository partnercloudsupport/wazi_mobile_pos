import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/pages/checkout/keypad_widget.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

class CombinedKeypadWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return _buildKeyPadWidget(context);
    // return ScopedModelDescendant<AppState>(
    //   builder: (BuildContext context, Widget child, AppState state) {
    //     return DefaultTabController(
    //       length: 3,
    //       child: Scaffold(
    //         appBar: AppBar(
    //             title: Text("Inventory"),
    //             backgroundColor: Theme.of(context).primaryColor,
    //             elevation: 5.0,
    //             centerTitle: true,
    //             bottom: TabBar(
    //               tabs: <Widget>[
    //                 Tab(
    //                   icon: Icon(Icons.category),
    //                   text: "Categories",
    //                 ),
    //                 Tab(
    //                   icon: Icon(Icons.image),
    //                   text: "Products",
    //                 ),
    //               ],
    //             )),
    //         body: TabBarView(
    //           children: <Widget>[_buildKeyPadWidget(context), Text("tab 2")],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }

  Widget _buildKeyPadWidget(BuildContext context) {
    var height = MediaQuery.of(context).size.height * 0.6;
    var width = MediaQuery.of(context).size.width;

    return Container(
      height: height,
      width: width,
      child: KeypadWidget(),
    );
  }
}
