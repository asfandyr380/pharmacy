import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Supplier/supplier.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class NewSupplierViewModel extends ChangeNotifier {
  SupplierService _supplierService = locator<SupplierService>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
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
      notifyListeners();
    }
  }

  updateSupplier(UserModel? m) async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        int p = int.parse(phoneController.text);
        await _supplierService
            .updateSupplier(nameController.text, emailController.text, p,
                addressController1.text, addressController2.text, m!.id!)
            .then((value) {
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController1.clear();
          addressController2.clear();
          setBusy(false);
        });
      }
    }
  }

  createSupplier() async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        int p = int.parse(phoneController.text);
        await _supplierService
            .createNewSupplier(nameController.text, emailController.text, p,
                addressController1.text, addressController2.text)
            .then((value) {
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController1.clear();
          addressController2.clear();
          setBusy(false);
        });
      }
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
