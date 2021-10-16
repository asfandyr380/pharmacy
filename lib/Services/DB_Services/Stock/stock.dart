import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/stock_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class StockService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future addStock(
    String name,
    int quantity,
    int batchNo,
    double buyingPrice,
    double sellingPrice,
  ) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.query(
      'insert into stock (name, quantity, batchNo, buyingPrice, salePrice) values(?, ?, ?, ?, ?)',
      [name, quantity, batchNo, buyingPrice, sellingPrice],
    );
    _conn.close();
  }

  Future addMultipleStock(List<ProductModel> model, String? shelf) async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.queryMulti(
      'insert into stock (name, quantity, batchNo, buyingPrice, salePrice, user_Id, shelf) values(?, ?, ?, ?, ?, ?, ?)',
      [
        for (var m in model)
          [
            m.name,
            m.quantity,
            m.batchNo,
            m.unit,
            m.salePrice,
            user!.userId,
            shelf ?? ''
          ]
      ],
    );
    _conn.close();
  }

  Future subtractStock(List<ProductModel> model) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();
    await _conn.queryMulti(
      'update stock set quantity = quantity - ? where batchNo = ? and user_Id = ?',
      [
        for (var m in model) [m.quantity * m.packs!, m.batchNo, user!.userId]
      ],
    );
    _conn.close();
    await checkstockQuantity(model);
  }

  Future subtractStock1(List<SoldMedicineModel> model) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();

    await _conn.queryMulti(
      'update stock set quantity = quantity - ? where batchNo = ? and user_Id = ?',
      [
        for (var m in model) [m.quantity * m.packs, m.batchNo, user!.userId]
      ],
    );
    _conn.close();
    await checkstockQuantity1(model);
  }

  Future returnStock(
      List<SoldMedicineModel> model, List<SoldMedicineModel> oldModel) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();

    await _conn.queryMulti(
      'update stock set quantity = quantity + ? where batchNo = ? and user_Id = ?',
      [
        for (int i = 0; i < model.length; i++)
          [
            (oldModel[i].quantity * oldModel[i].packs -
                model[i].quantity * model[i].packs),
            model[i].batchNo,
            user!.userId
          ]
      ],
    );
    _conn.close();
    // await checkstockQuantity(model);
  }

  checkstockQuantity1(List<SoldMedicineModel> model) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();
    for (var m in model) {
      var result = await _conn.query(
          'select stock_Id, quantity from stock where batchNo = ? and user_Id = ?',
          [m.batchNo, user!.userId]);
      for (var r in result) {
        if (r[1] == 0) {
          await _conn.query(
            'delete from stock where stock_Id = ?',
            [m.id],
          );
        }
      }
    }
    _conn.close();
  }

  checkstockQuantity(List<ProductModel> model) async {
    MySqlConnection _conn = await _connection.establishConnection();
    UserSetting? user = await LocalStorage.getUserSetting();
    for (var m in model) {
      var result = await _conn.query(
          'select stock_Id, quantity from stock where batchNo = ? and user_Id = ?',
          [m.batchNo, user!.userId]);
      for (var r in result) {
        if (r[1] == 0) {
          await _conn.query(
            'delete from stock where stock_Id = ?',
            [m.id],
          );
        }
      }
    }
    _conn.close();
  }

  Future removeStock(List<ProductModel> model) async {
    MySqlConnection _conn = await _connection.establishConnection();
    await _conn.queryMulti(
      'delete from stock where batchNo = ?',
      [
        for (var m in model) [m.batchNo]
      ],
    );
    _conn.close();
  }

  Future getStock() async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query(
        'select stock_Id, name, quantity, batchNo, buyingPrice, salePrice from stock where user_Id = ${user!.userId}');
    _conn.close();
    List<StockModel> stocklist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'quantity': field[2],
        'batchNo': field[3],
        'buyingPrice': field[4],
        'sellingPrice': field[5],
      };
      var model = StockModel.fromJson(maped);
      stocklist.add(model);
    }
    return stocklist;
  }

  Future searchStock(String name) async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    int? id = int.tryParse(name);
    var results;
    if (id != null) {
      results = await _conn.query(
          'select stock_Id, name, quantity, batchNo, buyingPrice, salePrice from stock where stock_Id = $id and user_Id = ${user!.userId}');
    } else {
      results = await _conn.query(
          'select stock_Id, name, quantity, batchNo, buyingPrice, salePrice from stock where name like "$name%" and user_Id = ${user!.userId}');
    }
    _conn.close();
    List<StockModel> stocklist = [];
    for (var field in results) {
      var maped = {
        'id': field[0],
        'name': field[1],
        'quantity': field[2],
        'batchNo': field[3],
        'buyingPrice': field[4],
        'sellingPrice': field[5],
      };
      var model = StockModel.fromJson(maped);
      stocklist.add(model);
    }
    return stocklist;
  }

  Future countTotalStock() async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn
        .query('select quantity from stock where user_Id = ${user!.userId}');
    _conn.close();
    int qnt = 0;
    for (var count in result) {
      qnt = qnt + count[0] as int;
    }
    return qnt;
  }
}
