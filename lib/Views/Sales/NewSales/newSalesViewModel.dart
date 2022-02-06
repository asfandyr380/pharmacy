import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:medical_store/Config/Utils/brains.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/invoice_model.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/stock_model.dart';
import 'package:medical_store/Models/user_setting_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Services/Printing/pdf_service.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';
import 'package:printing/printing.dart';

class NewSalesViewModel extends ChangeNotifier {
  // Initialize Everything That is Needed
  init() {
    getUserSetting();
    Future.delayed(Duration(milliseconds: 100), () {
      if (connection) {
        getCustomers();
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
        print(disc);
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
    priceController.dispose();
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

  getCustomers() async {
    List<UserModel> result = await _customersService.getCustomers(50, 0);
    customerlist = result;
    notifyListeners();
  }
  // Fetch Customer

  // Product List Saving
  TextEditingController medicineController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountController = TextEditingController(text: "0");
  TextEditingController paidController = TextEditingController(text: '0');
  List<ProductModel> productlist = [];
  double totalAmt = 0;
  bool isGreater = true;

  removeProduct(ProductModel model) {
    productlist.remove(model);
    totalAmt -= model.amount;
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
        final double salePrice = num.tryParse(priceController.text)!.toDouble();
        // final int packs = int.parse(packController.text);
        final double amt = (qty * salePrice);
        final double finalAmt = amt - (amt * disc / 100);
        if (qty > _selectedMedicine!.totalQuantity) {
          isGreater = false;
          notifyListeners();
        } else {
          isGreater = true;
          ProductModel model = ProductModel(
            amount: finalAmt,
            discount: disc,
            packs: 1,
            unit: unt,
            salePrice: salePrice,
            id: _selectedMedicine!.id,
            batchNo: _selectedMedicine!.batchNo,
            name: _selectedMedicine!.name,
            quantity: qty,
          );
          productlist.add(model);
          totalAmt = Brains.calculateProductTotalAmt(productlist);
          grandTotalController.text = totalAmt.toStringAsFixed(2);
          notifyListeners();
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
          priceController.clear();
          discountController.text = '0';
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
    priceController.text = val.sellingPrice.toString();
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

  saveSale(BuildContext context) async {
    if (connection) {
      if (productlist.isNotEmpty) {
        setBusy(true);

        double cashDiscount = double.parse(discountController1.text);
        double grandtotal = double.parse(grandTotalController.text);
        double? tax = double.tryParse(taxController.text);
        final paid = double.tryParse(paidController.text);
        num previous = 0;
        if (selectedCustomer != null) {
          previous = (grandtotal + selectedCustomer!.previous!) - (paid ?? 0);
        }
        print(previous);
        SalesModel model = SalesModel(
          total: totalAmt,
          discount: cashDiscount,
          grandTotal: grandtotal,
          note: sNote,
          date: currentDate,
          paid: paid ?? 0,
          tax: tax ?? 0,
          time: time.format(context),
          customerId: selectedCustomer != null ? selectedCustomer!.id : 0,
          previous: selectedCustomer!.previous != 0 ? previous : 0,
        );
        await _salesService.createNewSale(model).then((value) async {
          if (selectedCustomer != null) {
            await _customersService.updatePreviousBalance(
                selectedCustomer!.id!, previous.toDouble());
          }
          await _salesService
              .createSoldMedicine(productlist, value)
              .then((value) async {
            await _stockService.subtractStock(productlist);
          });
          _showConfirmDialog(context, model, value);
        });
        setBusy(false);
        selectedCustomer = null;
        productlist = [];
        totalAmt = 0;
        discountController1.text = "0";
        grandTotalController.clear();
        taxController.text = "0";
        paidController.text = "0";
      }
    }
  }

  _showConfirmDialog(BuildContext context, SalesModel model, int saleId) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text("Do you want footer or not ?"),
        actions: [
          TextButton(
              onPressed: () {
                printInvoice(model, saleId, true);
                Navigator.pop(_);
              },
              child: Text("Yes")),
          TextButton(
              onPressed: () {
                printInvoice(model, saleId, false);
                Navigator.pop(_);
              },
              child: Text("No")),
        ],
      ),
    );
  }

  printInvoice(SalesModel m, int saleId, bool showFooter) async {
    final invoice;
    List<SoldMedicineModel> result = await _salesService.getSale(saleId);

    if (m.customerId != 0) {
      var customer = await _customersService.getCustomer(m.customerId!);
      invoice =
          PdfInvoice(sale: m, soldMedicines: result, customer: customer[0]);
    } else {
      invoice = PdfInvoice(sale: m, soldMedicines: result);
    }

    await Printing.layoutPdf(
        onLayout: (format) => PdfInvoiceService.generate(invoice, showFooter));
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
