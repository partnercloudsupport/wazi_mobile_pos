import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/common/utils/hex_color.dart';
import 'package:wazi_mobile_pos/pages/home.dart';
import 'package:wazi_mobile_pos/pages/login.dart';
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
          primaryColor: HexColor("#773A95"), //LITTLE PURPLE
          accentColor: HexColor("#F05623"), //LIGHT ORANGE
          fontFamily: "Oswald",
          backgroundColor: Color.fromRGBO(237, 237, 237, 1.0),
        ),

        home: LoginPage(),
        routes: {
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => LoginPage()
        },
      ),
    );
  }
}
