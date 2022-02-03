import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:mysql1/mysql1.dart';

class MedicineService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getMedicine(int limit, int offset) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select medicine_Id, name, category, generic, company from medicine limit $limit offset $offset');
    _conn.close();
    List<MedicineModel> medicinelist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'category': field[2],
        'generic': field[3],
        'company': field[4],
      };
      var model = MedicineModel.fromJson(maped);
      medicinelist.add(model);
    }
    return medicinelist;
  }

  Future searchMedicine(String name) async {
    MySqlConnection _conn = await _connection.establishConnection();
    int? id = int.tryParse(name);
    var results;
    if (id != null) {
      results = await _conn.query(
          'select medicine_Id, name, category, generic, company from medicine where medicine_Id = $id');
    } else {
      results = await _conn.query(
          'select medicine_Id, name, category, generic, company from medicine where name like "$name%" or generic like "$name"');
    }
    _conn.close();
    List<MedicineModel> medicinelist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'category': field[2],
        'generic': field[3],
        'company': field[4]
      };

      var model = MedicineModel.fromJson1(maped);

      medicinelist.add(model);
    }
    print(medicinelist);

    return medicinelist;
  }

  Future addNewMedicine(
    String name,
    String category,
    String generic,
    String company,
  ) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'insert into medicine (name, category, generic, company) values(?, ?, ?, ?)',
      [name, category, generic, company],
    );
    _conn.close();
  }

  Future updateMedicine(String name, String category, String generic,
      String company, int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'update medicine set name = ?, category = ?, generic = ?, company = ? where medicine_Id = ?',
      [name, category, generic, company, id],
    );
    _conn.close();
  }

  Future removeMedicine(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'delete from medicine where medicine_Id = $id',
    );
    _conn.close();
  }

  Future countTotalMedicine() async {
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query('select count(medicine_Id) from medicine');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }
}
