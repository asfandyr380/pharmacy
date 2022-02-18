import 'package:medical_store/Models/report_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:medical_store/Models/users_model.dart';

class PdfInvoice {
  UserModel? customer;
  SalesModel sale;
  List<SoldMedicineModel> soldMedicines = [];
  ReportModel? reportModel;

  PdfInvoice({this.customer, required this.sale, required this.soldMedicines, this.reportModel});
}
