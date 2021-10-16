import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/category_model.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Services/DB_Services/Category/category.dart';
import 'package:medical_store/Services/DB_Services/Medicine/medicine.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class NewMedicineViewModel extends ChangeNotifier {
  CategoryService _categoryService = locator<CategoryService>();
  MedicineService _medicineService = locator<MedicineService>();

  List<String> catelist = [];
  String? selectedCate;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;
  TextEditingController nameController = TextEditingController();
  TextEditingController genericController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  // Dispose Stuff
  // bool _disposed = false;
  @override
  void dispose() {
    // _disposed = true;
    super.dispose();
    nameController.dispose();
    genericController.dispose();
    companyController.dispose();
  }

  // @override
  // void notifyListeners() {
  //   if (_disposed) {
  //     super.notifyListeners();
  //   }
  // }
  // Dispose Stuff

  init(MedicineModel? m) {
    if (connection) {
      getCategory();
    }
    if (m != null) {
      nameController.text = m.medicineName;
      genericController.text = m.generic;
      companyController.text = m.company;
      selectedCate = m.category;
      notifyListeners();
    }
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  getCategory() async {
    List<CategoryModel> result = await _categoryService.getCategories();
    for (var cate in result) {
      catelist.add(cate.name!);
    }
  }

  updateMedicine(MedicineModel? m) async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        await _medicineService.updateMedicine(
            nameController.text,
            selectedCate!,
            genericController.text,
            companyController.text,
            m!.id);
        nameController.clear();
        genericController.clear();
        companyController.clear();
        selectedCate = null;
        setBusy(false);
      }
    }
  }

  addMedicine() async {
    if (connection) {
      if (validateInput() == 1) {
        setBusy(true);
        await _medicineService.addNewMedicine(nameController.text,
            selectedCate!, genericController.text, companyController.text);
        nameController.clear();
        genericController.clear();
        companyController.clear();
        selectedCate = null;
        setBusy(false);
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
