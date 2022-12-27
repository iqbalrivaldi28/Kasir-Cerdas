import 'package:flutter/cupertino.dart';

class OperatorProvider extends ChangeNotifier {
  int? _amount;
  int _subUserId = 0;

  set amount(int? value) {
    _amount = value;
    notifyListeners();
  }

  set subUserId(int value) {
    _subUserId = value;
    notifyListeners();
  }

  int? get amount => _amount;
  int get subUserId => _subUserId;
}
