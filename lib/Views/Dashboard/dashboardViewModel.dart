import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Services/DB_Services/Medicine/medicine.dart';
import 'package:medical_store/Services/DB_Services/Purchase/purchase.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Services/DB_Services/Shelf/shelf.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/DB_Services/Supplier/supplier.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

class DashboardViewModel extends ChangeNotifier {
  ShelfService _shelfService = locator<ShelfService>();
  MedicineService _medicineService = locator<MedicineService>();
  StockService _stockService = locator<StockService>();
  SupplierService _supplierService = locator<SupplierService>();
  PurchaseService _purchaseService = locator<PurchaseService>();
  SalesService _saleService = locator<SalesService>();

  int shelfCount = 0;
  int medicineCount = 0;
  int stockCount = 0;
  int supplierCount = 0;
  int purchaseCount = 0;
  num purchaseAmount = 0;
  int salesCount = 0;
  num salesAmount = 0;
  num profit = 0;

  // Dispose Stuff
  // bool _disposed = false;
  // @override
  // void dispose() {
  //   _disposed = true;
  //   super.dispose();
  // }

  // @override
  // void notifyListeners() {
  //   if (_disposed) {
  //     super.notifyListeners();
  //   }
  // }
  // Dispose Stuff

  init() async {
    Future.delayed(Duration(microseconds: 1), () {
      if (connection) {
        getShelfCount();
        getMedicineCount();
        getStockCount();
        getSupplierCount();
        getPurchaseCount();
        getSaleCount();
        getpurchaseAmount();
        getsaleAmount();
      }
    });
    Future.delayed(Duration(seconds: 2), () {
      getProfit();
    });
  }

  getProfit() {
    profit = purchaseAmount - salesAmount;
    profit.abs();
    notifyListeners();
  }

  getShelfCount() async {
    int count = await _shelfService.countTotalShelf();
    shelfCount = count;
    notifyListeners();
  }

  getMedicineCount() async {
    int count = await _medicineService.countTotalMedicine();
    medicineCount = count;
    notifyListeners();
  }

  getStockCount() async {
    int count = await _stockService.countTotalStock();
    stockCount = count;
    notifyListeners();
  }

  getSupplierCount() async {
    int count = await _supplierService.countTotalSupplier();
    supplierCount = count;
    notifyListeners();
  }

  getPurchaseCount() async {
    int count = await _purchaseService.countTotalPurchase();
    purchaseCount = count;
    notifyListeners();
  }

  getSaleCount() async {
    int count = await _saleService.countTotalSales();
    salesCount = count;
    notifyListeners();
  }

  getpurchaseAmount() async {
    num? count = await _purchaseService.countTotalPurchaseAmount();
    purchaseAmount = count ?? 0;
    notifyListeners();
  }

  getsaleAmount() async {
    num? count = await _saleService.countTotalSalesAmount();
    salesAmount = count ?? 0;
    notifyListeners();
  }
}
