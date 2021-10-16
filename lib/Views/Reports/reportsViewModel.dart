import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class ReportsViewModel extends ChangeNotifier {
  List<SalesModel> saleslist = [];
  SalesService _salesService = locator<SalesService>();

  int limit = 10;
  int offset = 0;
  int pageNo = 1;
  bool lastPage = false;
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

  init() {
    if (connection) {
      getSales();
    }
  }

  update(SalesModel m) async {
    await _salesService.updateReceived(m);
  }

  getSales() async {
    List<SalesModel> result = await _salesService.getSales();
    saleslist = result;
    notifyListeners();
  }

  nextPage() {
    if (saleslist.length == 10) {
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
}
