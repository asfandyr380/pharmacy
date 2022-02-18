import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class CustomersService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getCustomers(int limit, int offset) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();
    var results = await _conn.query(
        'select customer_Id, name, email, phone, address1, address2, lisence_no, expiration_date, previous, last_report_Id from customer where user_Id = ${user!.userId} limit $limit offset $offset');
    _conn.close();
    List<UserModel> userlist = [];
    for (var field in results) {
      print(field);
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
        'lisence_no': field[6],
        'date': field[7],
        'previous': field[8],
        'report_Id': field[9],
      };
      var model = UserModel.fromJson(maped);
      userlist.add(model);
    }
    return userlist;
  }

  Future getCustomer(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();
    var results = await _conn.query(
        'select * from customer where customer_Id = $id && user_Id = ${user!.userId}');
    _conn.close();
    List<UserModel> userlist = [];
    for (var field in results) {
      print(field[6]);
      print(field);
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
        'lisence_no': field[7],
        'date': field[8],
        'previous': field[9],
        'report_Id': field[10],
      };
      var model = UserModel.fromJson(maped);
      userlist.add(model);
    }
    return userlist;
  }

  Future searchCustomer(String name) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();

    var results = await _conn.query(
        'select customer_Id, name, email, phone, address1, address2, lisence_no, expiration_date, last_report_Id from customer where name like "$name%" and user_Id = ${user!.userId}');
    _conn.close();
    List<UserModel> customerlist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
        'lisence_no': field[6],
        'date': field[7],
        'report_Id': field[8],
      };
      var model = UserModel.fromJson(maped);
      customerlist.add(model);
    }
    return customerlist;
  }

  Future updatePreviousBalance(int id, int reportId, double previous) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update customer set previous = ?, last_report_Id = ? where customer_Id = ?',
      [previous, reportId, id],
    );
    _conn.close();
  }

  Future updateCustomer(String name, String email, int phone, String address1,
      String address2, String lisence, String date, int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update customer set name = ?, email = ?, phone = ?, address1 = ?, address2 = ?, lisence_no = ?, expiration_date = ? where customer_Id = ?',
      [name, email, phone, address1, address1, lisence, date, id],
    );
    _conn.close();
  }

  Future createNewCustomer(String name, String? email, int? phone,
      String address1, String address2, String lisence, String date) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserModel? user = await LocalStorage.getUserInfo();

    await _conn.query(
      'insert into customer (name, email, phone, address1, address2, user_Id, lisence_no, expiration_date) values(?, ?, ?, ?, ?, ?, ?, ?)',
      [
        name,
        email ?? "",
        phone ?? 0, 
        address1,
        address2,
        user!.id,
        lisence,
        date,
      ],
    );
    _conn.close();
  }

  Future removeCustomer(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'delete from customer where customer_Id = $id',
    );
    _conn.close();
  }
}
