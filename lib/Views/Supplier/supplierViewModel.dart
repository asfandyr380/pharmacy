import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Supplier/supplier.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class SupplierViewModel extends ChangeNotifier {
  SupplierService _suppliersService = locator<SupplierService>();
  List<UserModel> supplierlist = [];
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
      getSupplier();
    }
  }

  getSupplier() async {
    List<UserModel> result = await _suppliersService.getSupplier(limit, offset);
    supplierlist = result;
    if (supplierlist.length < 10) {
      lastPage = true;
    } else {
      lastPage = false;
    }
    notifyListeners();
  }

  searchCutomer(String val) async {
    if (connection) {
      List<UserModel> result = await _suppliersService.searchSupplier(val);
      supplierlist = result;
      notifyListeners();
    }
  }

  removeSupplier(int id) async {
    if (connection) {
      await _suppliersService.removeSupplier(id).then((value) => getSupplier());
    }
  }

  nextPage() {
    if (supplierlist.length == 10) {
      if (connection) {
        pageNo++;
        offset += 10;
        notifyListeners();
        getSupplier();
      }
    }
  }

  previous() {
    if (pageNo != 1) {
      if (connection) {
        pageNo--;
        offset -= 10;
        notifyListeners();
        getSupplier();
      }
    }
  }
}
