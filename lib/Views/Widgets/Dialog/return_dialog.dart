import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Models/sold_medicine_model.dart';
import 'package:velocity_x/velocity_x.dart';

class returnDialog extends StatefulWidget {
  final List<SoldMedicineModel> m;
  final SalesModel sale;
  final Function(List<SoldMedicineModel>, SalesModel sale) submit;
  final Function(SoldMedicineModel) removeSoldMedicine;
  const returnDialog(this.m, this.submit, this.sale, this.removeSoldMedicine);

  @override
  _returnDialogState createState() => _returnDialogState();
}

class _returnDialogState extends State<returnDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Return'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            width: context.percentWidth * 40,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('Medicine Name'),
                Spacer(),
                Container(
                  width: context.percentWidth * 5,
                  child: Text('Qty'),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  width: context.percentWidth * 5,
                  child: Text('Packs'),
                ),
                SizedBox(
                  width: 20,
                ),

                Text('Total'),
                // SizedBox(
                //   width: 20,
                // ),
                // Container(
                //   width: context.percentWidth * 4,
                //   child: Text('Action'),
                // )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          for (var medicine in widget.m)
            Container(
              width: context.percentWidth * 40,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(medicine.medicineName),
                  Spacer(),
                  Container(
                    width: context.percentWidth * 5,
                    child: EditableTextWidget(
                      medicine: medicine,
                      onChange: (_) {
                        int? qty = int.tryParse(_);

                        if (qty != null) {
                          setState(() {
                            medicine.quantity = qty;
                            // medicine.totalAmt =
                            //     qty * medicine.packs * medicine.salePrice;
                            // medicine.totalAmt = medicine.totalAmt -
                            //     (medicine.totalAmt * medicine.discount / 100);
                            double totalAmt = 0;
                            for (var med in widget.m) {
                              med.totalAmt =
                                  med.quantity * med.packs * med.salePrice;
                              totalAmt += med.totalAmt -
                                  (med.totalAmt * med.discount / 100);
                              med.totalAmt = med.totalAmt -
                                  (med.totalAmt * med.discount / 100);
                            }
                            widget.sale.total = totalAmt;
                            widget.sale.grandTotal = widget.sale.total +
                                (widget.sale.total * widget.sale.tax / 100);

                            widget.sale.grandTotal =
                                widget.sale.grandTotal - widget.sale.discount;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Container(
                    width: context.percentWidth * 5,
                    child: EditableTextWidget1(
                      medicine: medicine,
                      onChange: (_) {
                        int? packs = int.tryParse(_);

                        if (packs != null) {
                          setState(() {
                            medicine.packs = packs;
                            // medicine.totalAmt =
                            //     packs * medicine.quantity * medicine.salePrice;
                            double totalAmt = 0;
                            for (var med in widget.m) {
                              med.totalAmt =
                                  med.quantity * med.packs * med.salePrice;

                              totalAmt += med.totalAmt -
                                  (med.totalAmt * med.discount / 100);
                              med.totalAmt = med.totalAmt -
                                  (med.totalAmt * med.discount / 100);
                            }
                            widget.sale.total = totalAmt;
                            widget.sale.grandTotal = widget.sale.total +
                                (widget.sale.total * widget.sale.tax / 100);

                            widget.sale.grandTotal =
                                widget.sale.grandTotal - widget.sale.discount;
                          });
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text('${medicine.totalAmt.toDoubleStringAsFixed()}'),
                  // SizedBox(
                  //   width: 20,
                  // ),
                  // Container(
                  //   width: context.percentWidth * 4,
                  //   child: IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           // widget.m.remove(medicine);
                  //           // widget.removeSoldMedicine(medicine);

                  //           medicine.quantity = 0;

                  //           // double totalAmt = 0;
                  //           // for (var med in widget.m) {
                  //           //   totalAmt += med.totalAmt -
                  //           //       (med.totalAmt * med.discount / 100);
                  //           //   med.totalAmt = med.totalAmt -
                  //           //       (med.totalAmt * med.discount / 100);
                  //           // }
                  //           // widget.sale.total = totalAmt +
                  //           //     (widget.sale.tax * widget.sale.total / 100);
                  //           // widget.sale.grandTotal =
                  //           //     widget.sale.total - widget.sale.discount;
                  //         });
                  //       },
                  //       icon: Icon(Icons.delete_forever, color: Colors.red)),
                  // )
                ],
              ),
            ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.bottomRight,
            child: Row(
              children: [
                Text(
                  'Grand Total',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                Text('${widget.sale.grandTotal.toDoubleStringAsFixed()}'),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              widget.submit(widget.m, widget.sale);
              Navigator.pop(context);
            },
            child: Text('Submit'))
      ],
    );
  }
}

class EditableTextWidget extends StatefulWidget {
  final SoldMedicineModel medicine;
  final Function(String)? onChange;
  const EditableTextWidget({required this.medicine, this.onChange});

  @override
  _EditableTextWidgetState createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (_) => widget.onChange!(_),
      initialValue: "${widget.medicine.quantity}",
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}

class EditableTextWidget1 extends StatefulWidget {
  final SoldMedicineModel medicine;
  final Function(String)? onChange;
  const EditableTextWidget1({required this.medicine, this.onChange});

  @override
  _EditableTextWidget1State createState() => _EditableTextWidget1State();
}

class _EditableTextWidget1State extends State<EditableTextWidget1> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (_) => widget.onChange!(_),
      initialValue: "${widget.medicine.packs}",
      decoration: InputDecoration(
        border: InputBorder.none,
      ),
    );
  }
}
