import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/purchase_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:mysql1/mysql1.dart';

class PurchaseService {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future createNewPurchase(PurchaseModel model) async {
    UserModel? user = await LocalStorage.getUserInfo();
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      var result = await _conn.query(
        'insert into purchase (grandTotal, total, date, user_Id, note) values(?, ?, ?, ?, ?)',
        [model.grandTotal, model.total, model.date, user!.id, model.note],
      );
      _conn.close();
      return result.insertId;
    } catch (e) {
      print(e);
    }
  }

  Future updatePurchase(PurchaseModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'update purchase set grandTotal = ?, total = ? where purchase_Id = ?',
        [
          model.grandTotal,
          model.total,
          model.purchaseCode,
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future createPurchasedMedicine(List<ProductModel> model, int id) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.queryMulti(
        'insert into purchase_medicine (medicine_name, purchase_Id, quantity, unitPrice, totalAmt, batchNo, salePrice) values( ?, ?, ?, ?, ?, ?, ?)',
        [
          for (var product in model)
            [
              product.name,
              id,
              product.quantity,
              product.unit,
              product.amount,
              product.batchNo,
              product.salePrice,
            ]
        ],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removePurchase(PurchaseModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from purchase where purchase_Id = ?',
        [model.purchaseCode],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removeMultiPurchasedMedicine(PurchaseModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from purchase_medicine where purchase_Id = ?',
        [model.purchaseCode],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future removePurchasedMedicine(ProductModel model) async {
    try {
      MySqlConnection _conn = await _connection.establishConnection();
      await _conn.query(
        'delete from purchase_medicine where id = ?',
        [model.id],
      );
      _conn.close();
    } catch (e) {
      print(e);
    }
  }

  Future countTotalPurchase() async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select count(purchase_Id) from purchase where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }

  Future countTotalPurchaseAmount() async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select sum(grandTotal) from purchase where user_Id = ${user!.userId}');
    _conn.close();
    for (var count in result) {
      return count[0];
    }
  }

  Future getPurchaseMedicine(PurchaseModel m) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select * from purchase_medicine where purchase_Id = ${m.purchaseCode}');
    _conn.close();

    List<ProductModel> purchaselist = [];
    for (var r in result) {
      var map = {
        'id': r[0],
        'name': r[1],
        'qty': r[3],
        'disc': r[4],
        'unit': r[5],
        'salePrice': r[6],
        'amt': r[7],
        'batch_no': r[8],
      };
      var purchase = ProductModel.fromJson(map);
      purchaselist.add(purchase);
    }
    return purchaselist;
  }

  Future getPurchases() async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn
        .query('select * from purchase where user_Id = ${user!.userId}');
    _conn.close();
    List<PurchaseModel> purchaselist = [];
    for (var r in result) {
      var map = {
        'id': r[0],
        'grandTotal': r[1],
        'total': r[2],
        'disc': r[3],
        'date': r[4],
        'note': r[6],
      };
      var purchase = PurchaseModel.fromJson(map);
      purchaselist.add(purchase);
    }
    return purchaselist;
  }

  Future searchPurchases(String id) async {
    UserSetting? user = await LocalStorage.getUserSetting();

    MySqlConnection _conn = await _connection.establishConnection();
    var result = await _conn.query(
        'select * from purchase where purchase_Id like "$id" and user_Id = ${user!.userId}');
    _conn.close();
    List<PurchaseModel> purchaselist = [];
    for (var r in result) {
      var map = {
        'id': r[0],
        'grandTotal': r[1],
        'total': r[2],
        'disc': r[3],
        'date': r[4],
        'note': r[6],
      };
      var purchase = PurchaseModel.fromJson(map);
      purchaselist.add(purchase);
    }
    return purchaselist;
  }
}
