import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class NewCustomerViewModel extends ChangeNotifier {
  CustomersService _customersService = locator<CustomersService>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController1 = TextEditingController();
  TextEditingController addressController2 = TextEditingController();
  TextEditingController lisenceController = TextEditingController();
  TextEditingController? dateController;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;

  DateTime selectedDate = DateTime.now();
  String currentDate = '';

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      currentDate = DateFormat.yMd().format(selectedDate);
      dateController!.text = currentDate;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (dateController != null) {
      dateController!.dispose();
    }
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController1.dispose();
    addressController2.dispose();
    lisenceController.dispose();
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  init(UserModel? m) {
    currentDate = DateFormat.yMd().format(selectedDate);
    dateController = TextEditingController(text: currentDate);
    if (m != null) {
      nameController.text = m.name!;
      emailController.text = m.email!;
      phoneController.text = m.phone.toString();
      addressController1.text = m.address1!;
      addressController2.text = m.address2!;
      dateController!.text = m.expirationDate!;
      lisenceController.text = m.licenceNo!;
      notifyListeners();
    }
  }

  updateCustomer(UserModel? m) async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        int p = int.parse(phoneController.text);
        print(p);
        await _customersService
            .updateCustomer(
          nameController.text,
          emailController.text,
          p,
          addressController1.text,
          addressController2.text,
          lisenceController.text,
          currentDate,
          m!.id!,
        )
            .then((value) {
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController1.clear();
          addressController2.clear();
          lisenceController.clear();
          dateController!.clear();
          setBusy(false);
        });
      }
    }
  }

  createCustomer() async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        int? p = int.tryParse(phoneController.text);
        await _customersService
            .createNewCustomer(
          nameController.text,
          emailController.text,
          p,
          addressController1.text,
          addressController2.text,
          lisenceController.text,
          currentDate,
        )
            .then((value) {
          nameController.clear();
          emailController.clear();
          phoneController.clear();
          addressController1.clear();
          addressController2.clear();
          lisenceController.clear();
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
