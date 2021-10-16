import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class EmployeeService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getEmployee(int limit, int offset) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select employee_Id, name, email, phone, address1, address2 phone, employee_user_Id from employee where user_Id = ${user!.id} limit $limit offset $offset');
    _conn.close();
    List<UserModel> employeelist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
        'employee_user_Id': field[6],
      };
      var model = UserModel.fromJson(maped);
      employeelist.add(model);
    }
    return employeelist;
  }

  Future searchEmployee(String name) async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select employee_Id, name, email, phone, address1, address2 phone, employee_user_Id from employee where name like "$name%" and user_Id = ${user!.id}');
    _conn.close();
    List<UserModel> employeelist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'email': field[2],
        'phone': field[3],
        'address1': field[4],
        'address2': field[5],
        'employee_user_Id': field[6],
      };
      var model = UserModel.fromJson(maped);
      employeelist.add(model);
    }
    return employeelist;
  }

  Future createNewEmployee(String name, String email, int phone,
      String address1, String address2, int emID) async {
    UserModel? user = await LocalStorage.getUserInfo();

    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'insert into employee (name, email, phone, address1, address2, user_Id, employee_user_Id) values(?, ?, ?, ?, ?, ?, ?)',
      [name, email, phone, address1, address2, user!.id, emID],
    );
    _conn.close();
  }

  Future updateEmployee(String name, String email, int phone, String address1,
      String address2, int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update employee set name = ?, email = ?, phone = ?, address1 = ?, address2 = ? where employee_Id = ?',
      [name, email, phone, address1, address2, id],
    );
    _conn.close();
  }

  Future removeEmployee(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'delete from employee where employee_Id = $id',
    );
    _conn.close();
  }
}
