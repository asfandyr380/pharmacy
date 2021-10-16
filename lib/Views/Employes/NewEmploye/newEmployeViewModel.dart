import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Auth_Services/User/user.dart';
import 'package:medical_store/Services/DB_Services/Employee/employee.dart';

class NewEmployeViewModel extends ChangeNotifier {
  EmployeeService _employeeService = locator<EmployeeService>();
  UserService _userService = locator<UserService>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  init(UserModel? m) {
    if (m != null) {
      nameController.text = m.name!;
      emailController.text = m.email!;
      phoneController.text = m.phone.toString();
      addressController1.text = m.address1!;
      addressController2.text = m.address2!;
      passwordController.text = 'password';
      notifyListeners();
    }
  }

  updateEmployee(UserModel? m) async {
    if (validateInput() == 1) {
      setBusy(true);
      int p = int.parse(phoneController.text);
      await _employeeService
          .updateEmployee(
        nameController.text,
        emailController.text,
        p,
        addressController1.text,
        addressController2.text,
        m!.id!,
      )
          .then((value) async {
        await _userService.updateEmployee(
          nameController.text,
          emailController.text,
          p,
          m.employeeUserId!,
        );
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController1.clear();
        addressController2.clear();
        passwordController.clear();
        setBusy(false);
      });
    }
  }

  createEmployee() async {
    if (validateInput() == 1) {
      setBusy(true);
      int p = int.parse(phoneController.text);
      await _userService
          .createNewUser(
        nameController.text,
        emailController.text,
        p,
        passwordController.text,
      )
          .then((id) async {
        await _employeeService.createNewEmployee(
          nameController.text,
          emailController.text,
          p,
          addressController1.text,
          addressController2.text,
          id,
        );
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController1.clear();
        addressController2.clear();
        passwordController.clear();
        setBusy(false);
      });
    }
  }

  validateInput() {
    var formState = formKey.currentState;
    if (formState!.validate()) {
      return 1;
    } else {
      mode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }
}
