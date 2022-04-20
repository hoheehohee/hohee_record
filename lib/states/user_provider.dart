import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:hohee_record/constants/shared_pref_key.dart';
import 'package:hohee_record/data/user_model.dart';
import 'package:hohee_record/repo/user_service.dart';
import 'package:hohee_record/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    initUser();
  }

  User? _user;
  UserModel? _userModel;

  void initUser() {
    logger.d("##### userProvider start");
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      await _setNewUser(user);
      logger.d('user status - $user');
      notifyListeners();
    });
  }˚

  Future _setNewUser(User? user) async {
    _user = user;
    if (user != null && user.phoneNumber != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String address = prefs.getString(SHARED_ADDRESS) ?? "";
      double lat = prefs.getDouble(SHARED_LAT) ?? 0;
      double lon = prefs.getDouble(SHARED_LON) ?? 0;
      String phoneNumber = user.phoneNumber!;
      String userKey = user.uid;

      UserModel userModel = UserModel(
          userKey: "",
          phoneNumber: phoneNumber,
          address: address,
          geoFirePoint: GeoFirePoint(lat, lon),
          createDate: DateTime.now().toUtc()
      );

      await UserService().createNewUser(userModel.toJson(), userKey);
      _userModel = await UserService().getUserModel(userKey);

      logger.d("##### _userModel: ${_userModel!.toJson()}");
    }
  }

  User? get user => _user;
}
