import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/shelf_model.dart';

import 'package:medical_store/Services/DB_Services/Shelf/shelf.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class ShelfViewModel extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode validateMode = AutovalidateMode.disabled;
  ShelfService _service = locator<ShelfService>();
  List<ShelfModel> shelflist = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController noController = TextEditingController();

  bool isLoading = false;
  // Dispose Stuff
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    nameController.dispose();
    noController.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  init() {
    if (connection) {
      getShelf();
    }
  }

  remove(ShelfModel shelf) {
    if (connection) {
      _service.removeShelf(shelf.shelfId!).then((value) {
        shelflist.remove(shelf);
        notifyListeners();
      });
    }
  }

  getShelf() async {
    List<ShelfModel> result = await _service.getShelf();
    shelflist = result;
    notifyListeners();
  }

  addNewShelf() async {
    if (connection) {
      var formResult = validateInput();
      if (formResult == 1) {
        setBusy(true);
        await _service
            .addNewShelf(nameController.text, int.parse(noController.text), 1)
            .then((value) {
          getShelf();
        });
        setBusy(false);
        nameController.clear();
        noController.clear();
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
