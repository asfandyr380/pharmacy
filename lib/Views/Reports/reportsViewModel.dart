import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/report_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Services/DB_Services/Purchase/purchase.dart';
import 'package:medical_store/Services/DB_Services/Reports/report_services.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class ReportsViewModel extends ChangeNotifier {
  List<ReportModel> reports = [];
  SalesService _salesService = locator<SalesService>();
  PurchaseService _purchaseService = locator<PurchaseService>();
  ReportServices _reportService = locator<ReportServices>();

  int limit = 10;
  int offset = 0;
  int pageNo = 1;
  bool lastPage = false;
  String selectedFilter = "1 Month";
  num salesAmt = 0;
  num purchaseAmount = 0;
  int salesCount = 0;
  int purchaseCount = 0;
  num profit = 0;

  init() {
    if (connection) {
      getsaleAmount();
      getpurchaseAmount();
      getPurchaseCount();
      getSaleCount();
      Future.delayed(Duration(seconds: 2), () {
        getProfit();
      });
      getReports();
    }
  }

  getProfit() {
    profit = purchaseAmount - salesAmt;
    profit.abs();
    notifyListeners();
  }

  getsaleAmount() async {
    num? count =
        await _salesService.countTotalSalesAmountByFilter(selectedFilter);
    salesAmt = count ?? 0;
    notifyListeners();
  }

  getpurchaseAmount() async {
    num? count =
        await _purchaseService.countTotalPurchaseAmountByFilter(selectedFilter);
    purchaseAmount = count ?? 0;
    notifyListeners();
  }

  getPurchaseCount() async {
    int count =
        await _purchaseService.countTotalPurchasebyFilter(selectedFilter);
    purchaseCount = count;
    notifyListeners();
  }

  getSaleCount() async {
    int count = await _salesService.countTotalSalesByFilter(selectedFilter);
    salesCount = count;
    notifyListeners();
  }

  selectfilter(String val) {
    salesAmt = 0;
    purchaseAmount = 0;
    salesCount = 0;
    purchaseCount = 0;
    profit = 0;
    selectedFilter = val;
    notifyListeners();
    getsaleAmount();
    getpurchaseAmount();
    getPurchaseCount();
    getSaleCount();
    Future.delayed(Duration(seconds: 2), () {
      getProfit();
    });
  }

  update(SalesModel m) async {
    await _salesService.updateReceived(m);
  }

  getReports() async {
    List<ReportModel> res = await _reportService.getReports();
    reports = res;
    notifyListeners();
  }


  nextPage() {
    if (reports.length == 10) {
      if (connection) {
        pageNo++;
        offset += 10;
        notifyListeners();
        // getEmployee();
      }
    }
  }

  previous() {
    if (pageNo != 1) {
      if (connection) {
        pageNo--;
        offset -= 10;
        notifyListeners();
        // getEmployee();
      }
    }
  }

  // Dispose Stuff
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
// Dispose Stuff
}
