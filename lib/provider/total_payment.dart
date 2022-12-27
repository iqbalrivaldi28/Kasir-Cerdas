import 'package:flutter/cupertino.dart';

class TotalPaymentProvider extends ChangeNotifier {
  int _profit = 0;
  int _omset = 0;

  set setProfit(int value) {
    _profit = value;
    notifyListeners();
  }

  set setOmset(int value) {
    _omset = value;
    notifyListeners();
  }

  int get profit => _profit;
  int get omset => _omset;
}
