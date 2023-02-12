import '../utility/base.dart';

import 'item.dart';

class Expansion {
  Expansion({
    @required this.headerValue,
    this.isExpanded = false, 
    @required this.child,
    @required this.average
  });

  DateTime headerValue;
  bool isExpanded;
  List<Item> child;
  double average;
}