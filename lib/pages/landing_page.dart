import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class LandingPage extends StatelessWidget {
  Widget _buildButtonRow(
      Color buttonColor, Color textColor, String label, double height,
      {Function onPressed}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      child: RaisedButton(
        color: buttonColor,
        elevation: 10.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: TextStyle(
                        fontFamily: "Oswald", color: textColor, fontSize: 16.0),
                  ),
                ),
                flex: 1)
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildButtonColumn(
      Color buttonColor, Color textColor, String label, double height,
      {Function onPressed}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: RaisedButton(
        color: buttonColor,
        elevation: 10.0,
        child: Text(
          label,
          style:
              TextStyle(fontFamily: "Oswald", color: textColor, fontSize: 16.0),
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildButtonSection(BuildContext context, AppState state) {
    Color color = Theme.of(context).primaryColor;
    var orientation = MediaQuery.of(context).orientation;

    var buttonHeight = 52.0; //(MediaQuery.of(context).size.height * 0.4) / 5;

    return Container(
        margin: EdgeInsets.only(top: 24.0),
        child: orientation == Orientation.portrait
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildButtonRow(
                      color, Colors.white, 'Create Account', buttonHeight,
                      onPressed: () => _navigateRegister(context, state)),
                  SizedBox(
                    height: 16.0,
                  ),
                  _buildButtonRow(Colors.white, color, 'Sign In', buttonHeight,
                      onPressed: () => _navigateLogin(context)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: _buildButtonColumn(
                          color, Colors.white, 'Create Account', buttonHeight,
                          onPressed: () => _navigateRegister(context, state))),
                  Expanded(
                      child: _buildButtonColumn(
                          Colors.white, color, 'Sign In', buttonHeight,
                          onPressed: () => _navigateLogin(context)))
                ],
              ));
  }

  void _navigateRegister(BuildContext context, AppState state) {
    //state.sendCodeToPhone("+27833791749");
    Navigator.of(context).pushNamed("/register");
  }

  void _navigateLogin(BuildContext context) {
    Navigator.of(context).pushNamed("/login");
  }

  Widget _buildCarouselItem(
      {@required BuildContext context,
      @required String image,
      @required String title,
      @required String subTitle}) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(image,
                  width: screenWidth,
                  height: screenHeight * 0.225,
                  fit: BoxFit.fitHeight,
                  alignment: Alignment.center),
              SizedBox(
                height: 16.0,
              ),
              DecoratedText(
                title,
                textColor: Colors.white,
                alignment: Alignment.center,
                fontSize: 36.0,
              ),
              DecoratedText(
                subTitle,
                textColor: Colors.white,
                alignment: Alignment.center,
                fontSize: 18.0,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCarousel(BuildContext context, double height, double width) {
    List<Widget> _items = [
      _buildCarouselItem(
          context: context,
          image: "assets/merchanticon.png",
          subTitle: "Designed to make you succeed",
          title: "Digital Store"),
      _buildCarouselItem(
          context: context,
          image: "assets/tillpoint2.png",
          subTitle: "Run and grow your business",
          title: "Point of Sale"),
      _buildCarouselItem(
          context: context,
          image: "assets/inventory.png",
          subTitle: "Never run out of stock",
          title: "Inventory Management"),
      _buildCarouselItem(
          context: context,
          image: "assets/customers.png",
          subTitle: "Build strong relationships",
          title: "Customer Management"),
      _buildCarouselItem(
          context: context,
          image: "assets/reporting.png",
          subTitle: "Know everything always",
          title: "Online Reporting"),
      _buildCarouselItem(
          context: context,
          image: "assets/staffmanagement.png",
          subTitle: "Manage your teams effectively always",
          title: "Staff Management")
    ];

    return SizedBox(
      height: height,
      width: width,
      child: Swiper(
        itemWidth: width,
        itemCount: _items.length,
        itemBuilder: (c, i) {
          return Container(
            color: Theme.of(context).accentColor,
            child: _items[i],
          );
          // return Image.asset("assets/bg_portrait.jpg",fit: BoxFit.fitHeight,);
        },
        autoplay: true,
        autoplayDelay: 10000,
        duration: 5000,
        autoplayDisableOnInteraction: true,
        layout: SwiperLayout.DEFAULT,
        pagination: SwiperPagination(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return Scaffold(
          body: Column(
            children: <Widget>[
              _buildCarousel(context, screenHeight * 0.6, screenWidth),
              _buildButtonSection(context, state),
              Divider(
                height: 16.0,
              ),
              DecoratedText(
                "Brought to you by LittleFish Technologies",
                alignment: Alignment.center,
              )
            ],
          ),
        );
      },
    );
  }
}
