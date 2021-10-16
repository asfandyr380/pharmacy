import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';

class LowStockViewModel extends ChangeNotifier {
  bool isVisible = false;
  int? sortColumnIndex;
  bool sortAscending = false;
  late List<dynamic> medicinelist;
  DataSource dataSource = locator<DataSource>();

  close() {
    isVisible = false;
    notifyListeners();
  }

  List<DataCell> dataCell(dynamic) {
    return <DataCell>[
      DataCell(Text(dynamic.medicineName)),
      DataCell(Text('${dynamic.batchNo}')),
      DataCell(Text("${dynamic.totalQuantity}")),
      DataCell(Text('${dynamic.sellingPrice.toStringAsFixed(2)}')),
      DataCell(Text('${dynamic.buyingPrice.toStringAsFixed(2)}')),
    ];
  }

  init(BuildContext ctx) {
    medicinelist = <MedicineModel>[];

    dataSource = DataSource(
        context: ctx, data: medicinelist, getCell: (_) => dataCell(_));
  }

  void sort<T>(
    Comparable<T> Function(dynamic d) getField,
    int columnIndex,
    bool ascending,
  ) {
    dataSource.sort<T>(getField, ascending);
    sortColumnIndex = columnIndex;
    sortAscending = ascending;
    notifyListeners();
  }

  List<DataColumn> get dataColumns {
    return [
      DataColumn(
        label: Text('Medicine Name'),
        onSort: (columnIndex, ascending) =>
            sort<String>((d) => d.medicineName, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Batch No'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.batchNo, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Total Quantity'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.totalQuantity, columnIndex, ascending),
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
