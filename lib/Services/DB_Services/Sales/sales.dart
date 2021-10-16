import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class SalesService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future createNewSale(SalesModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      UserSetting? user = await LocalStorage.getUserSetting();
      var result = await _conn.query(
        'insert into sales (customer_Id, total, discount, grandTotal, date, user_Id, note, advance_tax, time) values(?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          model.customerId,
          model.total,
          model.discount,
          model.grandTotal,
          model.date,
          user!.userId,
          model.note,
          model.tax,
          model.time,
        ],
      );
      _conn.close();
      return result.insertId;
    } catch (e) {
      print(e);
    }
  }

  Future updateReceived(SalesModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'update sales set received = ? where sale_Id = ?',
        [
          model.received,
          model.id,
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future updateSale(SalesModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'update sales set grandTotal = ?, total = ? where sale_Id = ?',
        [
          model.grandTotal,
          model.total,
          model.id,
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future updateSoldMedicine(List<SoldMedicineModel> model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.queryMulti(
        'update sold_medicine set quantity = ?, totalAmt = ?, packs = ? where id = ?',
        [
          for (var product in model)
            [
              product.quantity,
              product.totalAmt,
              product.packs,
              product.id,
            ]
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removeSale(SalesModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from sales where sale_Id = ?',
        [model.id],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removeMultiSoldMedicine(SalesModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from sold_medicine where sale_Id = ?',
        [model.id],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removeSoldMedicine(SoldMedicineModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from sold_medicine where sale_Id = ?',
        [model.saleId],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removeSoldMedicine1(SoldMedicineModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from sold_medicine where id = ?',
        [model.id],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future createSoldMedicine(List<ProductModel> model, int id) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.queryMulti(
        'insert into sold_medicine (sale_Id, medicine_name, quantity, unitPrice, salePrice, batchNo, discount, totalAmt, packs) values(?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          for (var product in model)
            [
              id,
              product.name,
              product.quantity,
              product.unit,
              product.salePrice,
              product.batchNo,
              product.discount,
              product.amount,
              product.packs,
            ]
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future createSoldMedicine1(List<SoldMedicineModel> model, int id) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.queryMulti(
        'insert into sold_medicine (sale_Id, medicine_name, quantity, unitPrice, salePrice, batchNo, discount, totalAmt, packs) values(?, ?, ?, ?, ?, ?, ?, ?, ?)',
        [
          for (var product in model)
            [
              id,
              product.medicineName,
              product.quantity,
              product.unitPrice,
              product.salePrice,
              product.batchNo,
              product.discount,
              product.totalAmt,
              product.packs,
            ]
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future countTotalSales() async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select count(sale_Id) from sales where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }

  Future countTotalSalesAmount() async {
    UserSetting? user = await LocalStorage.getUserSetting();
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select sum(grandTotal) from sales where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }

  Future getSale(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var result =
        await _conn.query('select * from sold_medicine where sale_Id = $id');
    _conn.close();
    List<SoldMedicineModel> saleslist = [];
    print(result);
    for (var r in result) {
      var map = {
        'id': r[0],
        'sale_Id': r[1],
        'name': r[2],
        'qnt': r[3],
        'packs': r[4],
        'unt': r[5],
        'salePrice': r[6],
        'batch_no': r[7],
        'disc': r[8],
        'total': r[9],
      };
      var sale = SoldMedicineModel.fromJson(map);
      saleslist.add(sale);
    }
    return saleslist;
  }

  Future getSales() async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn
        .query('select * from sales where user_Id = ${user!.userId}');
    _conn.close();
    List<SalesModel> saleslist = [];
    for (var r in result) {
      var map = {
        'id': r[0],
        'customer_Id': r[1],
        'total': r[2],
        'disc': r[3],
        'grandTotal': r[4],
        'date': r[6],
        'note': r[7],
        'tax': r[8],
        'time': r[9],
        'received': r[10],
      };
      var sale = SalesModel.fromJson(map);
      saleslist.add(sale);
    }
    return saleslist;
  }

  Future searchSales(String id) async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select * from sales where sale_Id like "$id" and user_Id = ${user!.userId}');
    _conn.close();
    List<SalesModel> saleslist = [];
    for (var r in result) {
      var map = {
        'id': r[0],
        'customer_Id': r[1],
        'total': r[2],
        'disc': r[3],
        'grandTotal': r[4],
        'date': r[6],
        'note': r[7],
      };
      var sale = SalesModel.fromJson(map);
      saleslist.add(sale);
    }
    return saleslist;
  }
}
