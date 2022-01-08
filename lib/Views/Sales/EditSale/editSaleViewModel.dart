import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/stock_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class EditSaleViewModel extends ChangeNotifier {
  // Initialize Everything That is Needed
  init(SalesModel m) {
    getUserSetting();
    Future.delayed(Duration(milliseconds: 100), () {
      if (connection) {
        getCustomers(m);
        getProductlist(m.id!);
        totalAmt = m.total.toDouble();
        taxController.text = m.tax.toString();
        discountController1.text = m.discount.toString();
        currentDate = m.date;
        paidController.text = m.paid.toString();
        notifyListeners();
      }
    });

    currentDate = DateFormat.yMd().format(selectedDate);
    controller = TextEditingController(text: currentDate);
    notifyListeners();
    discountController1.addListener(() {
      grandTotalController.text = totalAmt.toString();

      if (discountController1.text.isNotEmpty) {
        double? cashDiscount = double.tryParse(discountController1.text);
        if (cashDiscount != null) {
          double grandAmt = double.parse(grandTotalController.text);
          double f = grandAmt - cashDiscount;
          grandTotalController.text = f.toStringAsFixed(2);
          notifyListeners();
        }
      }
      if (taxController.text.isNotEmpty) {
        double? disc = double.tryParse(taxController.text);
        print(disc);
        if (disc != null) {
          double grandAmt = double.parse(grandTotalController.text);
          double f = grandAmt + (grandAmt * disc / 100);
          grandTotalController.text = f.toStringAsFixed(2);
          notifyListeners();
        }
      }
    });
    taxController.addListener(() {
      grandTotalController.text = totalAmt.toString();

      if (taxController.text.isNotEmpty) {
        double? disc = double.tryParse(taxController.text);
        if (disc != null) {
          double grandAmt = double.parse(grandTotalController.text);
          double f = grandAmt + (grandAmt * disc / 100);
          grandTotalController.text = f.toStringAsFixed(2);
          notifyListeners();
        }
      }
      if (discountController1.text.isNotEmpty) {
        double? cashDiscount = double.tryParse(discountController1.text);
        if (cashDiscount != null) {
          double grandAmt = double.parse(grandTotalController.text);
          double f = grandAmt - cashDiscount;
          grandTotalController.text = f.toStringAsFixed(2);
          notifyListeners();
        }
      }
    });
  }
  // Initialize Everything That is Needed

  getProductlist(int id) async {
    List<SoldMedicineModel> result = await _salesService.getSale(id);
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
    packController.dispose();
    taxController.dispose();
    discountController.dispose();
    grandTotalController.dispose();
    discountController1.dispose();
    paidController.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
  // Dispose Stuff

  // Date Picker
  DateTime selectedDate = DateTime.now();
  String currentDate = '';
  TimeOfDay time = TimeOfDay.now();
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
  // Date Picker

  // Fetch Customer
  List<UserModel> customerlist = [];
  CustomersService _customersService = locator<CustomersService>();
  UserModel? selectedCustomer;

  getCustomers(SalesModel m) async {
    List<UserModel> result = await _customersService.getCustomers(50, 0);
    customerlist = result;
    notifyListeners();
    if (m.customerId != 0) {
      var customer = await _customersService.getCustomer(m.customerId!);
      selectedCustomer = customer[0];
      notifyListeners();
    }
  }
  // Fetch Customer

  // Product List Saving
  TextEditingController medicineController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController packController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController paidController = TextEditingController();
  List<SoldMedicineModel> productlist = [];
  List<SoldMedicineModel> newProducts = [];
  double totalAmt = 0;
  bool isGreater = true;
  removeProduct(SoldMedicineModel model) async {
    productlist.remove(model);
    totalAmt -= model.totalAmt;
    await _salesService.removeSoldMedicine1(model);
    grandTotalController.text = totalAmt.toStringAsFixed(2);
    if (discountController1.text.isNotEmpty) {
      double? cashDiscount = double.tryParse(discountController1.text);
      if (cashDiscount != null) {
        double grandAmt = double.parse(grandTotalController.text);
        double f = grandAmt - cashDiscount;
        grandTotalController.text = f.toStringAsFixed(2);
        notifyListeners();
      }
    }
    if (taxController.text.isNotEmpty) {
      double? disc = double.tryParse(taxController.text);
      print(disc);
      if (disc != null) {
        double grandAmt = double.parse(grandTotalController.text);
        double f = grandAmt + (grandAmt * disc / 100);
        grandTotalController.text = f.toStringAsFixed(2);
        notifyListeners();
      }
    }
  }

  savetolist() async {
    if (connection) {
      if (validateInput() == 1) {
        final int qty = int.parse(quantityController.text);
        final double disc = double.parse(discountController.text);
        final double unt = _selectedMedicine!.buyingPrice.toDouble();
        final double salePrice = _selectedMedicine!.sellingPrice.toDouble();
        final int packs = int.parse(packController.text);
        final double amt = (qty * salePrice);
        final double finalAmt = amt - (amt * disc / 100);
        final int finalQty = qty * packs;
        if (finalQty > _selectedMedicine!.totalQuantity) {
          isGreater = false;
          notifyListeners();
        } else {
          isGreater = true;
          SoldMedicineModel model = SoldMedicineModel(
            totalAmt: finalAmt,
            discount: disc,
            packs: packs,
            unitPrice: unt,
            salePrice: salePrice,
            id: _selectedMedicine!.id,
            batchNo: _selectedMedicine!.batchNo,
            medicineName: _selectedMedicine!.name,
            quantity: qty,
          );
          productlist.add(model);
          newProducts.add(model);
          double total = 0;
          for (var l in productlist) {
            total += l.totalAmt;
          }
          totalAmt = total;
          grandTotalController.text = totalAmt.toStringAsFixed(2);

          if (taxController.text.isNotEmpty) {
            double? disc = double.tryParse(taxController.text);
            if (disc != null) {
              double grandAmt = double.parse(grandTotalController.text);
              double f = grandAmt + (grandAmt * disc / 100);
              grandTotalController.text = f.toStringAsFixed(2);
              notifyListeners();
            }
          }
          if (discountController1.text.isNotEmpty) {
            double? cashDiscount = double.tryParse(discountController1.text);
            if (cashDiscount != null) {
              double grandAmt = double.parse(grandTotalController.text);
              double f = grandAmt - cashDiscount;
              grandTotalController.text = f.toStringAsFixed(2);
              notifyListeners();
            }
          }

          notifyListeners();
          medicineController.clear();
          quantityController.clear();
          packController.clear();
          discountController.clear();
          paidController.clear();
        }
      }
    }
  }
  // Product List Saving

  // Selecting and Searching Medicine
  StockService _stockService = locator<StockService>();
  StockModel? _selectedMedicine;
  String buyPrice = '0';
  onMedicineSelect(StockModel val) {
    medicineController.text = val.name;
    _selectedMedicine = val;
    buyPrice = _selectedMedicine!.buyingPrice.toString();
    notifyListeners();
  }

  Future searchMedicine(String val) async {
    if (connection) {
      if (val.isNotEmpty) {
        List<StockModel> result = await _stockService.searchStock(val);
        return result;
      } else
        return [];
    }
  }
  // Selecting and Searching Medicine

  // Form Validation
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode mode = AutovalidateMode.disabled;

  validateInput() {
    var formState = formKey.currentState;
    if (formState!.validate()) {
      return 1;
    } else {
      mode = AutovalidateMode.onUserInteraction;
      notifyListeners();
    }
  }
  // Form Validation

  // get Sale Note From User Settings
  String sNote = '';
  getUserSetting() async {
    UserSetting? settings = await LocalStorage.getUserSetting();
    sNote = settings!.sNote;
  }
  // get Sale Note From User Settings

  // Saving Sale
  SalesService _salesService = locator<SalesService>();

  TextEditingController taxController = TextEditingController(text: "0");
  TextEditingController discountController1 = TextEditingController(text: "0");
  TextEditingController grandTotalController = TextEditingController(text: "0");

  saveSale(BuildContext context, int id) async {
    if (connection) {
      if (productlist.isNotEmpty) {
        setBusy(true);

        double cashDiscount = double.parse(discountController1.text);
        double grandtotal = double.parse(grandTotalController.text);
        double? tax = double.tryParse(taxController.text);
        double? paid = double.tryParse(paidController.text);
        SalesModel model = SalesModel(
          id: id,
          total: totalAmt,
          discount: cashDiscount,
          grandTotal: grandtotal,
          note: sNote,
          date: currentDate,
          tax: tax ?? 0,
          paid: paid ?? 0,
          time: time.format(context),
          customerId: selectedCustomer != null ? selectedCustomer!.id : 0,
        );
        await _salesService
            .createSoldMedicine1(newProducts, id)
            .then((value) async {
          await _stockService.subtractStock1(newProducts).then((value) async {
            await _salesService.updateSale(model);
          });
        });
        setBusy(false);
        productlist = [];
        totalAmt = 0;
        discountController1.text = "0";
        grandTotalController.clear();
        taxController.text = "0";
      }
    }
  }
  // Saving Sale

  // Loading Indication Setup
  bool isLoading = false;

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }
  // Loading Indication Setup

  // Show Buying Price Shortcut
  bool showPrice = false;
  FocusNode focusNode = FocusNode();

  onKeyPress(RawKeyEvent event) {
    if (event.data.logicalKey == LogicalKeyboardKey.f1) {
      if (event.runtimeType.toString() == 'RawKeyDownEvent') {
        if (showPrice) {
          showPrice = false;
        } else {
          showPrice = true;
        }
        notifyListeners();
      }
    }
  }
  // Show Buying Price Shortcut

}
