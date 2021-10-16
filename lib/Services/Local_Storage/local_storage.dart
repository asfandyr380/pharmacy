import 'dart:convert';

import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static saveUserInfo(UserModel model) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String user = jsonEncode(model);
    _preferences.setString('user', user);
  }

  static saveUserSetting(UserSetting model) async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    String user = jsonEncode(model);
    _preferences.setString('setting', user);
  }

  static Future<bool> checkUser() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return _preferences.getString('user') != null;
  }

  static Future<UserModel?> getUserInfo() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var user = _preferences.getString('user');
    Map userMap = jsonDecode(user!);
    var userModel = UserModel.fromJson(userMap);
    return userModel;
  }

  static Future<UserSetting?> getUserSetting() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    var user = _preferences.getString('setting');
    Map userMap = jsonDecode(user!);
    var userModel = UserSetting.fromJson(userMap);
    return userModel;
  }

  static Future<bool> removeUserInfo() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    return await _preferences.remove('user');
  }
}
