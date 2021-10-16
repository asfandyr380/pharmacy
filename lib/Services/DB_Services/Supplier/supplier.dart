import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class SupplierService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getSupplier(int limit, int offset) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select supplier_Id, name, email, phone, address1, address2 from supplier where user_Id = ${user!.id} limit $limit offset $offset');
    _conn.close();
    List<UserModel> supplierlist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
      };
      var model = UserModel.fromJson(maped);
      supplierlist.add(model);
    }
    return supplierlist;
  }

  Future searchSupplier(String name) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select supplier_Id, name, email, phone, address1, address2 from supplier where name like "$name%" and user_Id = ${user!.id}');
    _conn.close();
    List<UserModel> supplierlist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
      };
      var model = UserModel.fromJson(maped);
      supplierlist.add(model);
    }
    return supplierlist;
  }

  Future createNewSupplier(String name, String email, int phone,
      String address1, String address2) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'insert into supplier (name, email, phone, address1, address2, user_Id) values(?, ?, ?, ?, ?, ?)',
      [name, email, phone, address1, address2, user!.id],
    );
    _conn.close();
  }

  Future removeSupplier(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'delete from supplier where supplier_Id = $id',
    );
    _conn.close();
  }

  Future updateSupplier(String name, String email, int phone, String address1,
      String address2, int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update supplier set name = ?, email = ?, phone = ?, address1 = ?, address2= ? where supplier_Id = ?',
      [name, email, phone, address1, address2, id],
    );
    _conn.close();
  }

  Future countTotalSupplier() async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select count(supplier_Id) from supplier where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }
}
