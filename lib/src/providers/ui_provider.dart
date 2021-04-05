import 'package:flutter/cupertino.dart';

/// `ChangeNotifier` permite que este Widget sea escuchando
/// cuando cambie  por otro cuando
class UIProvider extends ChangeNotifier {
  int _selectedMenuOpt = 0;

  int get selectedMenuOpt {
    return this._selectedMenuOpt;
  }

  set selectedMenuOpt(int n) {
    this._selectedMenuOpt = n;
    // Notifica a los demas widgets
    notifyListeners();
  }
}
