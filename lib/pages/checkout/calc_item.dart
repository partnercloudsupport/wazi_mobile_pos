class CalcItem {
  int order;
  String value;
  CalcItemType type;

  CalcItem({this.order, this.value, this.type});
}

enum CalcItemType { normal, clear, submit }