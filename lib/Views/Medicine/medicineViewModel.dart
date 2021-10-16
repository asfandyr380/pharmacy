import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Services/DB_Services/Medicine/medicine.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class MedicineViewModel extends ChangeNotifier {
  MedicineService _medicineService = locator<MedicineService>();
  List<MedicineModel> medicinelist = [];
  int limit = 10;
  int offset = 0;
  int pageNo = 1;
  bool lastPage = false;

  init() {
    if (connection) {
      getMedicine();
    }
  }

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

  searchMedicine(String val) async {
    if (connection) {
      if (val.isNotEmpty) {
        List<MedicineModel> result = await _medicineService.searchMedicine(val);
        medicinelist = result;
        notifyListeners();
      } else
        getMedicine();
    }
  }

  getMedicine() async {
    List<MedicineModel> result =
        await _medicineService.getMedicine(limit, offset);
    medicinelist = result;
    if (medicinelist.length < 10) {
      lastPage = true;
    } else {
      lastPage = false;
    }
    notifyListeners();
  }

  remove(MedicineModel m) async {
    if (connection) {
      medicinelist.remove(m);
      notifyListeners();
      await _medicineService.removeMedicine(m.id);
    }
  }

  nextPage() {
    if (medicinelist.length == 10) {
      if (connection) {
        pageNo++;
        offset += 10;
        notifyListeners();
        getMedicine();
      }
    }
  }

  previous() {
    if (pageNo != 1) {
      if (connection) {
        pageNo--;
        offset -= 10;
        notifyListeners();
        getMedicine();
      }
    }
  }
}
