import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/category_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';

import 'package:mysql1/mysql1.dart';

class CategoryService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future getCategories() async {
    UserModel? user = await LocalStorage.getUserInfo();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select cate_Id, name, description, user_Id from category where user_Id = ${user!.id}');
    _conn.close();
    List<CategoryModel> categorylist = [];
    for (var field in results) {
      var maped = {'id': field[0], 'name': field[1], 'desc': field[2]};
      var model = CategoryModel.fromJson(maped);
      categorylist.add(model);
    }
    return categorylist;
  }

  Future addNewCate(String name, String desc, int userId) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
        'insert into category (name, description, user_Id) values(?, ?, ?)',
        [name, desc, userId]);
    _conn.close();
  }

  Future removeCate(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query('delete from category where cate_Id = $id');
    _conn.close();
  }
}
