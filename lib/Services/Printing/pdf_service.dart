import 'dart:typed_data';

import 'package:medical_store/Models/invoice_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Services/Local_Storage/local_storage.dart';
import 'package:medical_store/Views/Widgets/InvoiceWidgets/invoice_widgets.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceService {
  static Future<Uint8List> generate(PdfInvoice invoice) async {
    UserModel? user = await LocalStorage.getUserInfo();
    final pdf = Document();

    pdf.addPage(MultiPage(
      pageFormat: PdfPageFormat.a4,
        margin: EdgeInsets.zero,
        footer: (context) => buildFooter(user!),
        build: (context) => buildInvoice(invoice),
        header: (context) => buildHeader(invoice, user!)));
    return await pdf.save();
  }
}
