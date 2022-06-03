import 'package:flutter_flixandchill/helper/shared_preference.dart';
import 'package:flutter_flixandchill/model_class/user_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  Box<UserModel> _localDB = Hive.box<UserModel>("data");

  void addData(UserModel data) {
    _localDB.add(data);
  }

  int getLength() {
    return _localDB.length;
  }

  bool checkLogin(String username, String password) {
    bool found = false;
    for (int i = 0; i < getLength(); i++) {
      if (username == _localDB.getAt(i)!.username &&
          password == _localDB.getAt(i)!.password) {
        SharedPreference().setLogin(username);
        print("Login Success");
        found = true;
        break;
      } else {
        found = false;
      }
    }

    return found;
  }
}
