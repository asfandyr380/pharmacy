import 'package:medical_store/Config/Db_Config.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/report_model.dart';
import 'package:mysql1/mysql1.dart';

class ReportServices {
  DataBaseConnection _connection = locator<DataBaseConnection>();

  Future createReports(ReportModel data, String date) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var res = await _conn.query(
        'insert into report (customer_Id, debit, credit, balance, date) values(?, ?, ?, ?, ?)',
        [data.customer_Id, data.debit, data.credit, data.balance, date]);
    _conn.close();
    return res.insertId;
  }

  Future getReports() async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query('select * from report');
    _conn.close();
    List<ReportModel> reports = [];
    for (var field in results) {
      var maped = {
        'report_Id': field[0],
        'cus_Id': field[1],
        'debit': field[2],
        'credit': field[3],
        'balance': field[4],
        'previous': field[5],
        'date': field[6],
      };
      var model = ReportModel.fromJson(maped);
      reports.add(model);
    }
    return reports;
  }

  Future getReportsByCustomer(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query('select * from report where customer_Id = $id');
    _conn.close();
    List<ReportModel> reports = [];
    for (var field in results) {
      var maped = {
        'report_Id': field[0],
        'cus_Id': field[1],
        'debit': field[2],
        'credit': field[3],
        'balance': field[4],
        'previous': field[5],
        'date': field[6],
      };
      var model = ReportModel.fromJson(maped);
      reports.add(model);
    }
    return reports;
  }

  Future getReportsById(int id) async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results =
        await _conn.query('select * from report where report_Id = $id');
    _conn.close();
    List<ReportModel> reports = [];
    for (var field in results) {
      print(field);
      var maped = {
        'report_Id': field[0],
        'cus_Id': field[1],
        'debit': field[2],
        'credit': field[3],
        'balance': field[4],
        'previous': field[5],
        'date': field[6],
      };
      var model = ReportModel.fromJson(maped);
      reports.add(model);
    }
    return reports[0];
  }

  Future getReportsByFilter() async {
    MySqlConnection _conn = await _connection.establishConnection();
    var results = await _conn.query('select * from report');
    _conn.close();
    List<ReportModel> reports = [];
    for (var field in results) {
      var maped = {
        'report_Id': field[0],
        'cus_Id': field[1],
        'debit': field[2],
        'credit': field[3],
        'balance': field[4],
        'previous': field[5],
        'date': field[6],
      };
      var model = ReportModel.fromJson(maped);
      reports.add(model);
    }
    return reports;
  }
}
