import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/category_model.dart';
import 'package:medical_store/Services/DB_Services/Category/category.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class CategoryViewMode extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  CategoryService _service = locator<CategoryService>();
  List<CategoryModel> catelist = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();

  init() {
    if (connection) {
      getCategory();
    }
  }

  bool isLoading = false;
  // Dispose Stuff
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    nameController.dispose();
    descController.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  // Dispose Stuff

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  remove(CategoryModel shelf) {
    if (connection) {
      _service.removeCate(shelf.id!).then((value) {
        catelist.remove(shelf);
        notifyListeners();
      });
    }
  }

  getCategory() async {
    List<CategoryModel> result = await _service.getCategories();
    catelist = result;
    notifyListeners();
  }

  addNewCate() async {
    if (connection) {
      var formResult = validateInput();
      if (formResult == 1) {
        setBusy(true);
        await _service
            .addNewCate(nameController.text, descController.text, 1)
            .then((value) {
          getCategory();
        });
        setBusy(false);
        nameController.clear();
        descController.clear();
      }
    }
  }

  validateInput() {
    var formState = formKey.currentState;
    if (formState!.validate()) {
      return 1;
    } else {
      validateMode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }
}
