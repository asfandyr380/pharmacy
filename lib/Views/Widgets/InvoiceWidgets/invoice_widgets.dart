import 'package:medical_store/Models/invoice_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

List<Widget> buildInvoice(PdfInvoice invoice) => [
      _buildTitle(invoice),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      _buildProduct(invoice),
      Divider(),
      _buildSummery(invoice),
      Divider(),
    ];

Widget _buildTitle(PdfInvoice invoice) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Invoice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          )),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      Text(invoice.sale.note),
    ],
  );
}

Widget _buildProduct(PdfInvoice invoice) {
  var headers = [
    "Name",
    "Batch",
    "Qty",
    "Packs",
    "Rate",
    "Disc",
    "Total",
  ];

  final data = invoice.soldMedicines.map((item) {
    return [
      item.medicineName,
      "${item.batchNo}",
      "${item.quantity}",
      "${item.packs}",
      "${item.salePrice}",
      "${item.discount}%",
      "${item.totalAmt}",
    ];
  }).toList();

  return Table.fromTextArray(
      data: data,
      headers: headers,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.blueGrey100),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      });
}

Widget _buildSummery(PdfInvoice invoice) {
  return Container(
    alignment: Alignment.centerRight,
    child: Row(
      children: [
        Spacer(flex: 6),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildText('Net Total', '${invoice.sale.total}', false),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              _buildText('Advance Tax', '${invoice.sale.tax}%', false),
              Divider(),
              _buildText('Grand Total', '${invoice.sale.grandTotal}', false),
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildText(String title, String value, bool united) {
  TextStyle style = TextStyle(fontWeight: FontWeight.bold);
  return Container(
    width: united ? null : double.infinity,
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: style,
          ),
        ),
        Text(value, style: united ? null : style),
      ],
    ),
  );
}

Widget buildHeader(PdfInvoice invoice, UserModel user) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildCompanyInfo(user),
          _buildInvoiceInfo(invoice.sale, user),
          SizedBox(height: 4 * PdfPageFormat.cm),
        ],
      ),
    ],
  );
}

Widget _buildInvoiceInfo(SalesModel sale, UserModel user) {
  TextStyle style = TextStyle(fontWeight: FontWeight.bold);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            width: 3 * PdfPageFormat.cm,
            child: Text('Invoice No', style: style),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Container(
            // width: 3 * PdfPageFormat.cm,
            child: Text('${sale.id}'),
          ),
        ],
      ),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Row(
        children: [
          Container(
            width: 3 * PdfPageFormat.cm,
            child: Text('Invoice Date', style: style),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Container(
            // width: 3 * PdfPageFormat.cm,
            child: Text('${sale.date}'),
          ),
        ],
      ),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Row(
        children: [
          Container(
            width: 3 * PdfPageFormat.cm,
            child: Text('Time', style: style),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Container(
            // width: 3 * PdfPageFormat.cm,
            child: Text('${sale.time}'),
          ),
        ],
      ),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Row(
        children: [
          Container(
            width: 3 * PdfPageFormat.cm,
            child: Text('Employee', style: style),
          ),
          SizedBox(width: 2 * PdfPageFormat.cm),
          Container(
            // width: 3 * PdfPageFormat.cm,
            child: Text('${user.name}'),
          ),
        ],
      ),
    ],
  );
}

Widget _buildCompanyInfo(UserModel user) {
  TextStyle style = TextStyle(fontWeight: FontWeight.bold);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('${user.shopename}', style: style),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('${user.email}'),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('${user.phone}'),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('${user.address1}'),
    ],
  );
}

Widget buildFooter() => Center(
    child: Text(
        'This Software is Developed by Pro Creative Solution for Contact 00000000'));
