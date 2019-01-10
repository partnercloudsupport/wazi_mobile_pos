import 'package:meta/meta.dart';

class Target {
  String id;
  double targetAmount;
  TargetType type;
  String currency;

  Target({@required this.id, @required this.type, @required this.targetAmount, @required this.currency});
}

enum TargetType { daily, monthly, annually }
