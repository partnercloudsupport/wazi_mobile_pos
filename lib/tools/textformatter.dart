import 'package:intl/intl.dart';

class TextFormatter {
  static String formatCurrency(String textValue) {
    try {
      if (textValue == null || textValue.isEmpty) textValue = "0.00";
      var formatter = new NumberFormat("###,##0.00", "en_US");
      var formatValue = double.parse(textValue);
      var formattedText = formatter.format(formatValue / 100);
      return formattedText;
    } catch (e) {
      print(e);
    }

    return textValue;
  }

  static String toStringCurrency(double value) {
    try {
      if (value == null) return "0.00";
      var formatter = new NumberFormat("###,##0.00", "en_US");

      var formattedText = formatter.format(value / 100);
      return formattedText;
    } catch (e) {
      print(e);
    }

    return "0.00";
  }
}
