import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/purchase_model.dart';
import 'package:medical_store/Services/DB_Services/Purchase/purchase.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';
import 'package:medical_store/Views/Purchase/EditPurchase/editPurchase.dart';
import 'package:medical_store/Views/Widgets/ActionButton/actionbutton.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';

class PurchaseViewModel extends ChangeNotifier {
  int? sortColumnIndex;
  bool sortAscending = false;
  DataSource? dataSource;
  List<dynamic>? purchaselist;
  List<String> actions = ["Delete", 'Edit'];
  bool isLoading = false;

  PurchaseService _purchaseService = locator<PurchaseService>();
  StockService _stockService = locator<StockService>();

  Future<List<PurchaseModel>> getPurchses() async {
    return await _purchaseService.getPurchases();
  }

  searchPurchase(String val, BuildContext ctx) async {
    if (connection) {
      setBusy(true);
      var result;
      if (val.isEmpty) {
        result = await _purchaseService.getPurchases();
      } else {
        result = await _purchaseService.searchPurchases(val);
      }
      purchaselist = result;
      dataSource = DataSource(
          context: ctx, data: purchaselist, getCell: (_) => dataCell(_, ctx));
      notifyListeners();
      setBusy(false);
    }
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  List<DataCell> dataCell(dynamic, BuildContext context) {
    return <DataCell>[
      DataCell(Text("${dynamic.purchaseCode}")),
      DataCell(Text("${dynamic.total}")),
      DataCell(Text('${dynamic.grandTotal.toStringAsFixed(2)}')),
      DataCell(ActionButton(
          actions: actions, onChange: (_) => onChange(_, dynamic, context))),
    ];
  }

  onChange(String? val, PurchaseModel m, BuildContext context) {
    if (val == 'Edit') {
      editPurchase(m, context);
    } else if (val == 'Delete') {
      deletePurchase(m, context);
    }
  }

  editPurchase(PurchaseModel m, BuildContext context) async {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => EditPurchaseView(model: m)));
  }

  deletePurchase(PurchaseModel m, BuildContext ctx) async {
    var result = await _purchaseService.getPurchaseMedicine(m);
    await _stockService.removeStock(result);
    await Future.wait([
      _purchaseService.removePurchase(m),
      _purchaseService.removeMultiPurchasedMedicine(m),
    ]);

    setBusy(true);
    var results = await _purchaseService.getPurchases();
    purchaselist = results;
    dataSource = DataSource(
        context: ctx, data: purchaselist, getCell: (_) => dataCell(_, ctx));
    notifyListeners();
    setBusy(false);
  }

  init(BuildContext ctx) {
    if (connection) {
      getPurchses().then((val) {
        purchaselist = val;
        dataSource = DataSource(
            context: ctx, data: purchaselist, getCell: (_) => dataCell(_, ctx));
        notifyListeners();
      });
    }
  }

  void sort<T>(
    Comparable<T> Function(dynamic d) getField,
    int columnIndex,
    bool ascending,
  ) {
    dataSource!.sort<T>(getField, ascending);
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    notifyListeners();
  }

  List<DataColumn> get dataColumns {
    return [
      DataColumn(
        label: Text('Purcahse Code'),
        // numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.purchaseCode, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Total'),
        // numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.purchaseCode, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Grand Total'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.grandTotal, columnIndex, ascending),
      ),
      DataColumn(label: Text('Action'), numeric: true),
    ];
  }
}
