import 'package:medical_store/Models/invoice_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

List<Widget> buildInvoice(PdfInvoice invoice) => [
      _buildTitle(invoice),
      SizedBox(height: 0.8 * PdfPageFormat.cm),
      _buildProduct(invoice),
      Spacer(),
      Divider(),
      _buildSummery(invoice),
      Divider(),
    ];

Widget _buildTitle(PdfInvoice invoice) {
  return Center(
    child: Text(
      'Quatation',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
    ),
  );
}

Widget _buildProduct(PdfInvoice invoice) {
  var headers = [
    "Qty",
    "Product Name",
    "Pack",
    "Batch + Expiry",
    "T.Rate",
    "Disc",
    "Total",
  ];

  final data = invoice.soldMedicines.map((item) {
    return [
      "${item.quantity}",
      item.medicineName,
      "${item.packs}",
      "${item.batchNo}",
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
      cellHeight: 20,
      cellStyle: TextStyle(fontSize: 10),
      cellPadding: EdgeInsets.zero,
      cellDecoration: (_, __, ___) => BoxDecoration(
          border: Border.symmetric(
              horizontal: BorderSide(color: PdfColors.grey300))),
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerLeft,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
      });
}

Widget _buildSummery(PdfInvoice invoice) {
  num previous = 0;
  if (invoice.customer != null)
    previous = (invoice.sale.grandTotal + invoice.sale.previous!) -
        (invoice.sale.paid);

  return Container(
    alignment: Alignment.centerRight,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildText(
              'Total Items', "${invoice.soldMedicines.length}", false),
        ),
        SizedBox(width: 10),
        invoice.customer != null
            ? Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildText('Current Balance',
                        "${invoice.sale.grandTotal.toStringAsFixed(2)}", true),
                    _buildText('Previous', "${invoice.sale.previous}", true),
                    _buildText('Paid', "${invoice.sale.paid}", true),
                    _buildText(
                        'Balance', "${previous.toStringAsFixed(2)}", true),
                  ],
                ),
              )
            : Spacer(flex: 4),
        SizedBox(width: 10),
        Expanded(
          flex: 4,
          child: Column(
            children: [
              _buildText('Net Total',
                  '${invoice.sale.total.toStringAsFixed(2)}', false),
              SizedBox(height: 0.4 * PdfPageFormat.cm),
              _buildText('Advance Tax', '${invoice.sale.tax}%', false),
              Divider(),
              _buildText('Grand Total',
                  '${invoice.sale.grandTotal.toStringAsFixed(2)}', false),
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
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyInfo(user),
        invoice.customer != null
            ? _buildCustomerInfo(invoice.customer!)
            : Container(),
        _buildInvoiceInfo(invoice.sale, user),
      ],
    ),
  );
}

Widget _buildCustomerInfo(UserModel customer) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Cutomer', style: TextStyle(fontWeight: FontWeight.bold)),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('${customer.name}', style: TextStyle(fontSize: 12)),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('${customer.address1}', style: TextStyle(fontSize: 12)),
    ]);

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
  String shop_name = user.shopename ?? '';
  String email = user.email ?? '';
  String address = user.address1 ?? '';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('$shop_name', style: style.copyWith(fontSize: 18)),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('Email:'),
      SizedBox(height: 0.2 * PdfPageFormat.cm),
      Text('Company Address:'),
    ],
  );
}

Widget buildFooter(UserModel user) => Column(
      children: [
        Text('EXPIRY CLAIMS WILL BE ACCEPTED (7) MONTHS BEFORE EXPIRY'),
        Text('FORM 2A (see rule 19 & 30)'),
        Text(
            'Warranty under section 23(1)(i) of the Drug Act 1976 \nI being a person resident in pakistan carrying on business at company address under the \nname ${user.shopename} and being an authorised agent. do hereby give this warranty that the drugs sold by me \ndo not contravence in anyway in provisions of section 23 of the drug act 1976.'),
        Text(
            'Note: This Warranty does not apply to unani, Homeopathic, Bio Chemic System of medicineand general items',
            style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 0.3 * PdfPageFormat.cm),
        Text(
            'This Software is Developed by 6xperts Copyright © 2022 for Contact +923059797601'),
      ],
    );
