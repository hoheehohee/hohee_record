import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

import '../utils/logger.dart';

class UserProvider extends ChangeNotifier {
  bool _userLoggedIn = false;

  void setUserAuth(bool authState) {
logger.d("##### setUserAuth: $authState");
    _userLoggedIn = authState;
    notifyListeners();
  }

  bool get userState => _userLoggedIn;
}