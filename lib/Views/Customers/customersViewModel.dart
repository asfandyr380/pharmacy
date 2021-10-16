import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class CustomerViewModel extends ChangeNotifier {
  CustomersService _customersService = locator<CustomersService>();
  List<UserModel> customerlist = [];
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
      getCustomer();
    }
  }

  getCustomer() async {
    List<UserModel> result =
        await _customersService.getCustomers(limit, offset);
    customerlist = result;
    if (customerlist.length < 10) {
      lastPage = true;
    } else {
      lastPage = false;
    }
    notifyListeners();
  }

  searchCutomer(String val) async {
    if (connection) {
      List<UserModel> result = await _customersService.searchCustomer(val);
      customerlist = result;
      notifyListeners();
    }
  }

  removeCustomer(int id) async {
    if (connection) {
      await _customersService.removeCustomer(id).then((value) => getCustomer());
    }
  }

  nextPage() {
    if (customerlist.length == 10) {
      if (connection) {
        pageNo++;
        offset += 10;
        notifyListeners();
        getCustomer();
      }
    }
  }

  previous() {
    if (pageNo != 1) {
      if (connection) {
        pageNo--;
        offset -= 10;
        notifyListeners();
        getCustomer();
      }
    }
  }
}
