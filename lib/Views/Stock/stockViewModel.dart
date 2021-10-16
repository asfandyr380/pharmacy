import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';

import 'package:medical_store/Models/stock_model.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';

import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';

class StockViewModel extends ChangeNotifier {
  int? sortColumnIndex;
  bool sortAscending = false;
  DataSource? dataSource;
  List<dynamic>? stocklist;
  bool isLoading = false;
  StockService _stockService = locator<StockService>();

  Future<List<StockModel>> getStock() async {
    return await _stockService.getStock();
  }

  searchStock(String val, BuildContext ctx) async {
    if (connection) {
      setBusy(true);
      var result = await _stockService.searchStock(val);
      stocklist = result;
      dataSource = DataSource(
          context: ctx, data: stocklist, getCell: (_) => dataCell(_));
      notifyListeners();
      setBusy(false);
    }
  }

  List<DataCell> dataCell(dynamic) {
    return <DataCell>[
      DataCell(Text("${dynamic.name}")),
      DataCell(Text('${dynamic.totalQuantity}')),
      DataCell(Text("${dynamic.batchNo}")),
      DataCell(Text('${dynamic.sellingPrice}')),
      DataCell(Text('${dynamic.buyingPrice}')),
    ];
  }

  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  init(BuildContext ctx) async {
    if (connection) {
      setBusy(true);
      getStock().then((val) {
        stocklist = val;
        dataSource = DataSource(
            context: ctx, data: stocklist, getCell: (_) => dataCell(_));
        notifyListeners();
        setBusy(false);
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
        label: Text('Name'),
        // numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<String>((d) => d.name, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Total Quantity'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.batchNo, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Batch No'),
        onSort: (columnIndex, ascending) =>
            sort<String>((d) => d.totalQuantity, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Selling Price'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.sellingPrice, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Buying Price'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.buyingPrice, columnIndex, ascending),
      ),
    ];
  }
}
