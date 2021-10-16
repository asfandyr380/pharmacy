import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_store/Config/Utils/brains.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/purchase_model.dart';
import 'package:medical_store/Models/shelf_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Services/DB_Services/Medicine/medicine.dart';
import 'package:medical_store/Services/DB_Services/Purchase/purchase.dart';
import 'package:medical_store/Services/DB_Services/Shelf/shelf.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class EditPurchaseViewModel extends ChangeNotifier {
  // Save / Remove Product List
  List<ProductModel> productlist = [];
  List<ProductModel> newProducts = [];
  TextEditingController boxController = TextEditingController();
  TextEditingController buyingController = TextEditingController();
  TextEditingController saleController = TextEditingController();
  TextEditingController medicineController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController batchController = TextEditingController();
  double totalAmt = 0;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;

  remove(ProductModel model) async {
    productlist.remove(model);
    totalAmt -= model.amount;
    await _purchaseService.removePurchasedMedicine(model);
    grandTotalController.text = totalAmt.toStringAsFixed(2);
    notifyListeners();
  }

  savetolist(PurchaseModel m) {
    if (connection) {
      if (validateInput() == 1) {
        int qnt = int.parse(quantityController.text);
        int box = int.parse(boxController.text);
        int totalQnt = qnt * box;
        double unt = double.parse(buyingController.text);
        double salePrice = double.parse(saleController.text);
        double amt = (unt * totalQnt);
        ProductModel model = ProductModel(
          amount: amt,
          batchNo: batchController.text,
          unit: unt,
          id: _selectedMedicine!.id,
          name: _selectedMedicine!.medicineName,
          quantity: totalQnt,
          salePrice: salePrice,
        );
        productlist.add(model);
        newProducts.add(model);
        totalAmt = Brains.calculateProductTotalAmt(productlist);
        grandTotalController.text = totalAmt.toStringAsFixed(2);
        notifyListeners();
        quantityController.clear();
        medicineController.clear();
        batchController.clear();
        boxController.clear();
        buyingController.clear();
        saleController.clear();
      }
    }
  }

  // Save Product List

  // Select Medicine
  MedicineModel? _selectedMedicine;

  onMedicineSelect(MedicineModel val) {
    medicineController.text = val.medicineName;
    _selectedMedicine = val;
    notifyListeners();
  }
  // Select Medicine

  // Select Date
  DateTime selectedDate = DateTime.now();
  String currentDate = '';
  TextEditingController? controller;

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
      controller!.text = currentDate;
      notifyListeners();
    }
  }

  // Select Date

  // Set Loading State
  bool isLoading = false;

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }
  // Set Loading State

  // initialize

  init(PurchaseModel m) {
    currentDate = DateFormat.yMd().format(selectedDate);
    controller = TextEditingController(text: currentDate);
    notifyListeners();
    Future.delayed(Duration(milliseconds: 100), () {
      if (connection) {
        getShelf();
        getProductlist(m);
        totalAmt = m.total.toDouble();
        currentDate = m.date;
        grandTotalController.text = totalAmt.toString();
        notifyListeners();
      }
    });

    getUserSetting();
  }

  // initialize

  getProductlist(PurchaseModel m) async {
    List<ProductModel> result = await _purchaseService.getPurchaseMedicine(m);
    productlist = result;
    notifyListeners();
  }

  // get User Info
  String name = 'ADMIN';
  String role = '';
  getUser() async {
    var result = await LocalStorage.getUserInfo();
    if (result != null) {
      name = result.name!;
      role = result.role!;
      notifyListeners();
    }
  }
  // get User Info

  validateInput() {
    var formState = formkey.currentState;
    if (formState!.validate()) {
      return 1;
    } else {
      mode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }

  // Dispose Stuff
  bool _disposed = false;
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
    if (controller != null) {
      controller!.dispose();
    }
    medicineController.dispose();
    quantityController.dispose();
    batchController.dispose();
    noteController.dispose();
    grandTotalController.dispose();
    saleController.dispose();
    buyingController.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  // Dispose Stuff

  // Get Default Note From Settings
  TextEditingController noteController = TextEditingController();

  getUserSetting() async {
    UserSetting? setting = await LocalStorage.getUserSetting();
    noteController.text = setting!.pNote;
    notifyListeners();
  }
  // Get Default Note From Settings

  // Search Medicine
  MedicineService _medicineService = locator<MedicineService>();

  Future searchMedicine(String val) async {
    if (connection) {
      if (val.isNotEmpty) {
        List<MedicineModel> result = await _medicineService.searchMedicine(val);
        print(result);
        return result;
      } else
        return [];
    }
  }

  // Search Medicine
  TextEditingController grandTotalController = TextEditingController();
  PurchaseService _purchaseService = locator<PurchaseService>();
  StockService _stockService = locator<StockService>();
  savePurchase(PurchaseModel m) async {
    if (connection) {
      if (productlist.isNotEmpty) {
        setBusy(true);
        double grandtotal = double.parse(grandTotalController.text);
        PurchaseModel model = PurchaseModel(
            grandTotal: grandtotal,
            total: totalAmt,
            date: currentDate,
            note: noteController.text,
            purchaseCode: m.purchaseCode);

        String shelfName = selectedShlef == null ? '' : selectedShlef!.name!;
        int shelfNo = selectedShlef == null ? 0 : selectedShlef!.numericNo!;
        await _purchaseService
            .createPurchasedMedicine(newProducts, m.purchaseCode!)
            .then((value) async {
          await _stockService
              .addMultipleStock(
            newProducts,
            shelfNo == 0 ? '' : '$shelfName($shelfNo)',
          )
              .then((value) async {
            _purchaseService.updatePurchase(model);
          });
        });

        setBusy(false);
        productlist = [];
        totalAmt = 0;
        grandTotalController.clear();
        selectedShlef = null;
        notifyListeners();
      }
    }
  }

  ShelfService _shelfService = locator<ShelfService>();
  ShelfModel? selectedShlef;
  List<ShelfModel> shelflist = [];
  getShelf() async {
    List<ShelfModel> result = await _shelfService.getShelf();
    shelflist = result;
    notifyListeners();
  }
}
