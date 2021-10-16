import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Employee/employee.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class EmployesViewModel extends ChangeNotifier {
  EmployeeService _employeeService = locator<EmployeeService>();
  List<UserModel> employeelist = [];
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
      getEmployee();
    }
  }

  getEmployee() async {
    List<UserModel> result = await _employeeService.getEmployee(limit, offset);
    employeelist = result;
    if (employeelist.length < 10) {
      lastPage = true;
    } else {
      lastPage = false;
    }
    notifyListeners();
  }

  searchEmployee(String val) async {
    if (connection) {
      List<UserModel> result = await _employeeService.searchEmployee(val);
      employeelist = result;
      notifyListeners();
    }
  }

  removeEmployee(int id) async {
    if (connection) {
      await _employeeService.removeEmployee(id).then((value) => getEmployee());
    }
  }

  nextPage() {
    if (employeelist.length == 10) {
      if (connection) {
        pageNo++;
        offset += 10;
        notifyListeners();
        getEmployee();
      }
    }
  }

  previous() {
    if (pageNo != 1) {
      if (connection) {
        pageNo--;
        offset -= 10;
        notifyListeners();
        getEmployee();
      }
    }
  }
}
