import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/shelf_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class ShelfService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getShelf() async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select shelf_Id, name, no, user_Id from shelf where user_Id = ${user!.id}');
    _conn.close();

    List<ShelfModel> shelflist = [];
    for (var field in results) {
      var maped = {'id': field[0], 'name': field[1], 'numericNo': field[2]};
      var model = ShelfModel.fromJson(maped);
      shelflist.add(model);
    }
    return shelflist;
  }

  Future addNewShelf(String name, int no, int userId) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query('insert into shelf (name, no, user_Id) values(?, ?, ?)',
        [name, no, userId]);
    _conn.close();
  }

  Future removeShelf(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query('delete from shelf where shelf_Id = $id');
    _conn.close();
  }

  Future countTotalShelf() async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select count(shelf_Id) from shelf where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }
}
