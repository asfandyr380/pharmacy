import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class UserService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future createNewUser(
      String name, String email, int phone, String password) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
      'insert into users (name, shop_name, phone, email, password, role, settings_Id, address) values(?, ?, ?, ?, ?, ?, ?, ?)',
      [
        name,
        user!.shopename,
        phone,
        email,
        password,
        "Employee",
        user.settingId,
        user.address1,
      ],
    );
    _conn.close();
    return result.insertId;
  }

  Future updateEmployee(String name, String email, int phone, int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update users set name = ?, email = ?, phone = ? where user_Id = ?',
      [
        name,
        email,
        phone,
        id,
      ],
    );
    _conn.close();
  }
}
