import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/utils/hex_color.dart';
import 'package:wazi_mobile_pos/pages/checkout/checkout_page.dart';
import 'package:wazi_mobile_pos/pages/crm/client_page.dart';
import 'package:wazi_mobile_pos/pages/home.dart';
import 'package:wazi_mobile_pos/pages/inventory/inventory_page.dart';
import 'package:wazi_mobile_pos/pages/landing_page.dart';
import 'package:wazi_mobile_pos/pages/login.dart';
import 'package:wazi_mobile_pos/pages/register.dart';
import 'package:wazi_mobile_pos/pages/settings/settings_page.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: AppState(),
      child: MaterialApp(
        // debugShowMaterialGrid: true,
        theme: ThemeData(
          primaryColor: Colors.teal, //LITTLE PURPLE
          //accentColor: Colors.blueGrey, //LIGHT ORANGE
          // accentColor: HexColor("#A64AC9"),
          accentColor: HexColor("#FBA100"),
          fontFamily: "Oswald",
          backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
        ),
        home: LandingPage(),
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage(),
          '/register': (BuildContext context) => RegisterPage(),
          '/landing': (BuildContext context) => LandingPage(),
          '/customers': (BuildContext context) => ClientPage(),
          '/inventory': (BuildContext context) => InventoryPage(),
          '/settings': (BuildContext context) => SettingsPage(),
          "/checkout": (BuildContext context) => CheckoutPage()
        },
      ),
    );
  }
}
