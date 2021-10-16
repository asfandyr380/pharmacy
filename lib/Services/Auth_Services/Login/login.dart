import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class LoginService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future<UserModel?> loginUser(String email, String password) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();

      var results = await _conn.query(
          'select user_Id, name, email, phone, shop_name, role, password, settings_Id, address from users where email = "$email"');
      _conn.close();
      print(results);
      for (var user in results) {
        var map = {
          'id': user[0],
          'name': user[1],
          'email': user[2],
          'phone': user[3],
          'shop_name': user[4],
          'role': user[5],
          'password': user[6],
          'settings_Id': user[7],
          'address1': user[8],
        };

        if (map['password'] == password) {
          UserModel model = UserModel.fromJson(map);
          LocalStorage.saveUserInfo(model);
          getUserSettings(map['settings_Id']);
          return model;
        } else
          return null;
      }
    } catch (e) {
      print(e);
    }
  }

  getUserSettings(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select settings_Id, currency, web, purchase_note, sales_note, user_Id from user_settings where settings_Id = "$id"');
    _conn.close();
    for (var user in results) {
      var map = {
        'id': user[0],
        'currency': user[1],
        'web': user[2],
        'Pnote': user[3],
        'Snote': user[4],
        'user_Id': user[5],
      };
      UserSetting model = UserSetting.fromJson(map);
      LocalStorage.saveUserSetting(model);
    }
  }

  Future updateUserSetting(UserSetting model, UserModel uModel) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update user_settings set currency = ?, web = ?, purchase_note = ?, sales_note = ? where settings_Id = ?',
      [model.currency, model.web, model.pNote, model.sNote, model.id],
    );
    await _conn.query(
      'update users set shop_name = ?, email = ?, phone = ?, address = ? where user_Id = ?',
      [
        uModel.shopename,
        uModel.email,
        uModel.phone,
        uModel.address1,
        uModel.id,
      ],
    );
    _conn.close();
    getUserSettings(model.id);
  }
}
