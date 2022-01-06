import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/locator.dart';
import 'package:medical_store/Models/invoice_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Services/DB_Services/Customers/cutomers.dart';
import 'package:medical_store/Services/DB_Services/Sales/sales.dart';
import 'package:medical_store/Services/DB_Services/Stock/stock.dart';
import 'package:medical_store/Services/Printing/pdf_service.dart';
import 'package:medical_store/Views/LandingPage/landingViewModel.dart';
import 'package:medical_store/Views/Sales/EditSale/editSale.dart';
import 'package:medical_store/Views/Widgets/ActionButton/actionbutton.dart';
import 'package:medical_store/Views/Widgets/Dialog/return_dialog.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataSource.dart';
import 'package:printing/printing.dart';

class SalesViewModel extends ChangeNotifier {
  int? sortColumnIndex;
  bool sortAscending = false;
  DataSource? dataSource;
  List<dynamic>? saleslist;
  List<String> actions = ["Print Invoice", "Print Receipt", "Return", "Edit"];
  bool isLoading = false;
  SalesService _salesService = locator<SalesService>();
  CustomersService _customersService = locator<CustomersService>();
  StockService _stockService = locator<StockService>();
  setBusy(bool state) {
    isLoading = state;
    notifyListeners();
  }

  Future<List<SalesModel>> getSales() async {
    return await _salesService.getSales();
  }

  searchPurchase(String val, BuildContext ctx) async {
    if (connection) {
      setBusy(true);
      var result;
      if (val.isEmpty) {
        result = await _salesService.getSales();
      } else {
        result = await _salesService.searchSales(val);
      }
      saleslist = result;
      dataSource = DataSource(
          context: ctx, data: saleslist, getCell: (_) => dataCell(_, ctx));
      notifyListeners();
      setBusy(false);
    }
  }

  List<DataCell> dataCell(dynamic, BuildContext context) {
    return <DataCell>[
      DataCell(Text("${dynamic.id}")),
      DataCell(Text('${dynamic.total}')),
      DataCell(Text("${dynamic.discount}")),
      DataCell(Text('${dynamic.grandTotal.toStringAsFixed(2)}')),
      DataCell(Text('${dynamic.date}')),
      DataCell(ActionButton(
          actions: actions, onChange: (_) => onChange(_, dynamic, context))),
    ];
  }

  onChange(String? val, SalesModel m, BuildContext context) async {
    if (val == 'Print Invoice') {
      printInvoice(m);
    } else if (val == 'Print Receipt') {
      printReceipt();
    } else if (val == 'Return') {
      returnItem(m, context);
    } else if (val == 'Edit') {
      editSale(m, context);
    }
  }

  returnItem(SalesModel m, BuildContext context) async {
    List<SoldMedicineModel> result = await _salesService.getSale(m.id!);
    List<SoldMedicineModel> oldResult =
        result.map((e) => SoldMedicineModel.clone(e)).toList();
    showDialog(
        context: context,
        builder: (context) => returnDialog(
              result,
              (med, sale) async {
                if (med.isEmpty) {
                  // await _salesService.removeSale(sale);
                } else {
                  await Future.wait([
                    _salesService.updateSale(sale),
                    _salesService.updateSoldMedicine(med),
                    _stockService.returnStock(med, oldResult),
                  ]);
                }
              },
              m,
              (med) async {
                // await _salesService.removeSoldMedicine(med);
              },
            ));
  }

  printReceipt() async {}

  editSale(SalesModel m, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditSaleView(model: m),
      ),
    );
  }

  printInvoice(SalesModel m) async {
    final invoice;
    List<SoldMedicineModel> result = await _salesService.getSale(m.id!);
    if (m.customerId != 0) {
      var customer = await _customersService.getCustomer(m.customerId!);
      invoice = PdfInvoice(sale: m, soldMedicines: result, customer: customer[0]);
    } else {
      invoice = PdfInvoice(sale: m, soldMedicines: result);
    }
    await Printing.layoutPdf(
        onLayout: (format) => PdfInvoiceService.generate(invoice));
  }

  init(BuildContext ctx) {
    if (connection) {
      getSales().then((value) {
        saleslist = value;
        dataSource = DataSource(
            context: ctx, data: saleslist, getCell: (_) => dataCell(_, ctx));
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
        label: Text('Sale Code'),
        // numeric: true,
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.purchaseCode, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Total'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.name, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Cash Discount'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.paymentMethod, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Grand Total'),
        onSort: (columnIndex, ascending) =>
            sort<num>((d) => d.grandTotal, columnIndex, ascending),
      ),
      DataColumn(
        label: Text('Date'),
        onSort: (columnIndex, ascending) =>
            sort<String>((d) => d.status, columnIndex, ascending),
      ),
      DataColumn(label: Text('Action'), numeric: true),
    ];
  }
}
