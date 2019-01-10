import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:wazi_mobile_pos/models/trade/target.dart';
import 'package:wazi_mobile_pos/services/trade/target_service.dart';
import 'package:wazi_mobile_pos/states/app_state.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:wazi_mobile_pos/widgets/general/decorated_text.dart';

class TargetCard extends StatelessWidget {
  final double _currentEarnings = 475000.25;

  Widget _buildTargetWidget(BuildContext context, AppState state) {
    final targetService = TargetService(appState: state);
    final thisTarget = targetService.getTarget(TargetType.daily);
    final ccy = thisTarget.currency;
    Color progressColor = Colors.red;
    IconData progressIcon = Icons.arrow_downward;

    double achievedTarget = 0;

    if (_currentEarnings > thisTarget.targetAmount)
      achievedTarget = 100;
    else {
      achievedTarget = (_currentEarnings / thisTarget.targetAmount) * 100;
    }

    if (achievedTarget < 25) {
      progressColor = Colors.red;
      progressIcon = Icons.arrow_downward;
    } else if (achievedTarget <= 50) {
      progressColor = Colors.orange;
      progressIcon = Icons.arrow_downward;
    } else if (achievedTarget <= 75) {
      progressColor = Colors.orangeAccent;
      progressIcon = Icons.arrow_upward;
    } else if (achievedTarget <= 90) {
      progressColor = Colors.lightGreen;
      progressIcon = Icons.arrow_upward;
    } else if (achievedTarget <= 100) {
      progressColor = Colors.green;
      progressIcon = Icons.thumb_up;
    }

    return AnimatedContainer(
      duration: Duration(seconds: 3),
      child: CircularPercentIndicator(
        header: DecoratedText(
          "$_currentEarnings",
          alignment: Alignment.center,
          fontSize: 16.0,
        ),
        animationDuration: 750,
        radius: 150.0,
        lineWidth: 13.0,
        animation: true,
        percent: achievedTarget / 100,
        center: Icon(
          progressIcon,
          size: 64,
        ),
        footer: Column(
          children: <Widget>[
            DecoratedText(
              "Target Remaining ${ccy + (thisTarget.targetAmount - _currentEarnings).toString()}",
              fontSize: 16,
              alignment: Alignment.center,
            ),
          ],
        ),
        circularStrokeCap: CircularStrokeCap.square,
        progressColor: progressColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
      builder: (BuildContext context, Widget child, AppState state) {
        return SafeArea(
          top: false,
          bottom: false,
          child: Container(
            padding: EdgeInsets.all(8.0),
            child: Card(
                child: Column(
              children: <Widget>[
                DecoratedText(
                  "Today's Target",
                  fontWeight: FontWeight.bold,
                  alignment: Alignment.center,
                  fontSize: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 16.0, 16.0, 0),
                    child: _buildTargetWidget(context, state),
                  ),
                )
              ],
            )),
          ),
        );
      },
    );
  }
}
