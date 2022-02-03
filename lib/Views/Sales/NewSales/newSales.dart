import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/stock_model.dart';
import 'package:medical_store/Views/Sales/NewSales/newSalesViewModel.dart';
import 'package:medical_store/Views/Widgets/Box/box.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/SearchDropDown/searchdropdown.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewSalesView extends StatefulWidget {
  const NewSalesView({Key? key}) : super(key: key);

  @override
  _NewSalesViewState createState() => _NewSalesViewState();
}

class _NewSalesViewState extends State<NewSalesView> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewSalesViewModel>.reactive(
      viewModelBuilder: () => NewSalesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            SizedBox(height: 20),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: NewMedicineContent(
                  customerlist: model.customerlist,
                  onChange: (val) {
                    model.selectedCustomer = val;
                  },
                  medicineController: model.medicineController,
                  quantityController: model.quantityController,
                  packsController: model.priceController,
                  discountController: model.discountController,
                  paidController: model.paidController,
                  onSave: () => model.savetolist(),
                  onSearch: (_) => model.searchMedicine(_),
                  onSelect: (_) => model.onMedicineSelect(_),
                  formKey: model.formKey,
                  mode: model.mode,
                  onDelete: (_) => model.removeProduct(_),
                  productlist: model.productlist,
                  totalAmt: model.totalAmt,
                  taxController: model.taxController,
                  discountController1: model.discountController1,
                  grandTotalController: model.grandTotalController,
                  onSaveSale: () => model.saveSale(context),
                  isLoading: model.isLoading,
                  isGreater: model.isGreater,
                  isVisible: model.showPrice,
                  buyPrice: model.buyPrice,
                  node: model.focusNode,
                  onKey: (event) => model.onKeyPress(event),
                ),
                headerTxt: 'New Sale',
                isSearchable: true,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class NewMedicineContent extends StatelessWidget {
  final List customerlist;
  final Function? onChange;
  final TextEditingController? medicineController;
  final TextEditingController? quantityController;
  final TextEditingController? packsController;
  final TextEditingController? discountController;
  final Function? onSelect;
  final Function? onSearch;
  final Function? onSave;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode mode;
  final Function? onDelete;
  final List<ProductModel> productlist;
  final double totalAmt;
  final TextEditingController? taxController;
  final TextEditingController? discountController1;
  final TextEditingController? grandTotalController;
  final TextEditingController? paidController;
  final Function? onSaveSale;
  final bool? isLoading;
  final bool? isGreater;
  final String buyPrice;
  final bool isVisible;
  final FocusNode node;
  final Function? onKey;
  const NewMedicineContent({
    required this.customerlist,
    this.onChange,
    this.discountController,
    this.medicineController,
    this.packsController,
    this.quantityController,
    this.paidController,
    this.onSearch,
    this.onSelect,
    this.onSave,
    required this.formKey,
    required this.mode,
    required this.productlist,
    required this.totalAmt,
    this.onDelete,
    this.taxController,
    this.discountController1,
    this.grandTotalController,
    this.onSaveSale,
    this.isLoading,
    this.isGreater,
    required this.buyPrice,
    required this.isVisible,
    required this.node,
    this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewSalesViewModel>.reactive(
      viewModelBuilder: () => NewSalesViewModel(),
      onModelReady: (model) {},
      builder: (ctx, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldRow(
            customerlist: customerlist,
            onChange: (_) => onChange!(_),
          ),
          SizedBox(
            height: 50,
          ),
          ListingRow(
            medicineController: medicineController,
            quantityController: quantityController,
            packsController: packsController,
            discountController: discountController,
            paidController: paidController,
            onSave: () => onSave!(),
            onSearch: (_) => onSearch!(_),
            onSelect: (_) => onSelect!(_),
            formKey: formKey,
            mode: mode,
            onDelete: (_) => onDelete!(_),
            productlist: productlist,
            totalAmt: totalAmt,
            taxController: taxController,
            discountController1: discountController1,
            grandTotalController: grandTotalController,
            onSaveSale: () => onSaveSale!(),
            isLoading: isLoading,
            isGreater: isGreater,
            isVisible: isVisible,
            buyPrice: buyPrice,
            node: node,
            onKey: (_) => onKey!(_),
          ),
        ],
      ),
    );
  }
}

class FieldRow extends StatelessWidget {
  final Function? pickDate;
  final Function? onChange;
  final List customerlist;
  const FieldRow({this.pickDate, this.onChange, required this.customerlist});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewSalesViewModel>.reactive(
      viewModelBuilder: () => NewSalesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SearchDropDownHorizontal(
            items: customerlist,
            label: 'Customer',
            hint: 'Select Customer',
            onChanged: (_) => onChange!(_),
            validate: (_) {},
          ),
          GestureDetector(
            onTap: () => model.selectDate(context),
            child: AbsorbPointer(
              child: TextFieldWithLableHorizontal(
                hint: "Select Date",
                lable: "Date",
                readOnly: true,
                controller: model.controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingRow extends StatelessWidget {
  final TextEditingController? medicineController;
  final TextEditingController? quantityController;
  final TextEditingController? packsController;
  final TextEditingController? discountController;
  final Function? onSelect;
  final Function? onSearch;
  final Function? onSave;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode mode;
  final Function? onDelete;
  final List<ProductModel> productlist;
  final double totalAmt;
  final TextEditingController? taxController;
  final TextEditingController? discountController1;
  final TextEditingController? grandTotalController;
  final TextEditingController? paidController;
  final Function? onSaveSale;
  final bool? isLoading;
  final bool? isGreater;
  final String buyPrice;
  final bool isVisible;
  final FocusNode node;
  final Function? onKey;
  const ListingRow({
    this.discountController,
    this.medicineController,
    this.packsController,
    this.quantityController,
    this.paidController,
    this.onSearch,
    this.onSelect,
    this.onSave,
    required this.formKey,
    required this.mode,
    required this.productlist,
    this.onDelete,
    required this.totalAmt,
    this.taxController,
    this.discountController1,
    this.grandTotalController,
    this.onSaveSale,
    this.isLoading,
    this.isGreater,
    required this.buyPrice,
    required this.isVisible,
    required this.node,
    this.onKey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListingRowFields(
          medicineController: medicineController,
          quantityController: quantityController,
          packsController: packsController,
          discountController: discountController,
          onSave: () => onSave!(),
          onSearch: (_) => onSearch!(_),
          onSelect: (_) => onSelect!(_),
          formKey: formKey,
          mode: mode,
          isGreater: isGreater,
          isVisible: isVisible,
          buyPrice: buyPrice,
          node: node,
          onKey: (_) => onKey!(_),
        ),
        Column(
          children: [
            BoxWithLabel(
              boxContent: ListingContent(
                onDelete: (_) => onDelete!(_),
                productlist: productlist,
                totalAmt: totalAmt,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            ListingRowFields2(
              taxController: taxController,
              discountController: discountController1,
              grandTotalController: grandTotalController,
              paidController: paidController,
              onSaveSale: () => onSaveSale!(),
              isLoading: isLoading,
            )
          ],
        ),
      ],
    );
  }
}

class ListingRowFields2 extends StatelessWidget {
  final TextEditingController? taxController;
  final TextEditingController? discountController;
  final TextEditingController? grandTotalController;
  final TextEditingController? paidController;
  final Function? onSaveSale;
  final bool? isLoading;
  const ListingRowFields2({
    this.taxController,
    this.discountController,
    this.grandTotalController,
    this.paidController,
    this.onSaveSale,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFieldWithLable(
              hint: "Enter Advance Tax",
              lable: "Advance Tax",
              controller: taxController,
            ).box.width(context.percentWidth * 20).make(),
            SizedBox(
              height: context.percentHeight * 10,
            ),
            CustomButtonLarge(
              onPress: () => onSaveSale!(),
              text: "Save Sale",
              isLoading: isLoading,
            )
          ],
        ),
        SizedBox(
          width: context.percentWidth * 5,
        ),
        Column(
          children: [
            TextFieldWithLable(
              hint: "Enter Paid Ammount",
              lable: "Paid",
              controller: paidController,
            ).box.width(context.percentWidth * 15).make(),
            SizedBox(
              height: context.percentHeight * 5,
            ),
            TextFieldWithLable(
              hint: "Enter Discount",
              lable: "Cash Discount",
              controller: discountController,
            ).box.width(context.percentWidth * 15).make(),
            SizedBox(
              height: context.percentHeight * 5,
            ),
            TextFieldWithLable(
              hint: "Enter Amount",
              lable: "Grand Total",
              controller: grandTotalController,
            ).box.width(context.percentWidth * 15).make(),
          ],
        )
      ],
    );
    // SizedBox(
    //   height: 30,
    // ),
    // CustomButtonLarge(
    //   onPress: () => onSaveSale!(),
    //   text: "Save Sale",
    //   isLoading: isLoading,
    // )
  }
}

class ListingContent extends StatelessWidget {
  final Function? onDelete;
  final List<ProductModel> productlist;
  final double totalAmt;
  const ListingContent({
    this.onDelete,
    required this.productlist,
    required this.totalAmt,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader2(headerLables: [
          "#",
          "Name",
          "Price",
          "Qty",
          "Disc",
          "Amt",
          ""
        ], percentWidth: 5),
        for (var product in productlist)
          ListingTableData(
            onDelete: (_) => onDelete!(_),
            model: product,
          ),
        SizedBox(
          height: 15,
        ),
        "Total: ${totalAmt.toDoubleStringAsFixed()}"
            .text
            .xl
            .color(textColor)
            .make()
            .box
            .alignCenterRight
            .make()
            .pOnly(right: 75)
      ],
    );
  }
}

class ListingTableData extends StatelessWidget {
  final Function? onDelete;
  final ProductModel model;
  const ListingTableData({
    this.onDelete,
    required this.model,
  });
  @override
  Widget build(BuildContext context) {
    double _percentWidth = 5;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "${model.id}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.name}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.salePrice}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.quantity}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.discount}%"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.amount}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Vx.red500,
              ),
              onPressed: () => onDelete!(model),
            ).box.width(context.percentWidth * _percentWidth).make(),
          ],
        ),
        Divider(),
      ],
    );
  }
}

class ListingRowFields extends StatelessWidget {
  final TextEditingController? medicineController;
  final TextEditingController? quantityController;
  final TextEditingController? packsController;
  final TextEditingController? discountController;
  final Function? onSelect;
  final Function? onSearch;
  final Function? onSave;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode mode;
  final bool? isGreater;
  final String buyPrice;
  final bool isVisible;
  final FocusNode node;
  final Function? onKey;
  ListingRowFields({
    this.discountController,
    this.medicineController,
    this.packsController,
    this.quantityController,
    this.onSearch,
    this.onSelect,
    this.onSave,
    required this.formKey,
    required this.mode,
    this.isGreater,
    required this.buyPrice,
    required this.isVisible,
    required this.node,
    this.onKey,
  });

  FocusNode qtyNode = FocusNode();
  FocusNode medNode = FocusNode();
  FocusNode packFocus = FocusNode();
  FocusNode discFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: node,
      onKey: (_) => onKey!(_),
      autofocus: true,
      child: Form(
        key: formKey,
        autovalidateMode: mode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            'Quantity is Greater Then Medicine Quantity'
                .text
                .red500
                .make()
                .hide(isVisible: !isGreater!),
            SizedBox(height: 10),
            SearchfieldDropDown(
              label: 'Medicine',
              hint: "Select Medicine",
              onChanged: (_) => onSearch!(_),
              onSelect: (_) {
                onSelect!(_);
                FocusScope.of(context).requestFocus(qtyNode);
              },
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(qtyNode);
              },
              controller: medicineController,
              itemBuilder: (ctx, obj) {
                StockModel medicine = obj as StockModel;
                return ListTile(
                  title: Text(medicine.name),
                  trailing: 'Rs ${medicine.sellingPrice}'.text.make(),
                  leading: 'Qty ${medicine.totalQuantity}'.text.make(),
                  subtitle: 'Batch ${medicine.batchNo}'.text.make(),
                );
              },
              validate: (_) => InputValidation.emptyFieldValidation(_),
            ).box.width(context.percentWidth * 18.5).make(),
            SizedBox(height: 5),
            'Buy Price : $buyPrice'.text.make().hide(isVisible: isVisible),
            SizedBox(height: 20),
            TextFieldWithLable(
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(packFocus);
              },
              node: qtyNode,
              hint: 'Enter Quantity',
              lable: 'Quantity',
              controller: quantityController,
              validateForm: (_) => InputValidation.numericValueValidation(_),
            ).box.width(context.percentWidth * 18.5).make(),
            SizedBox(height: 20),
            TextFieldWithLable(
              node: packFocus,
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(discFocus);
              },
              hint: 'Enter Price',
              lable: 'Price',
              controller: packsController,
              validateForm: (_) => InputValidation.numericValueValidation(_),
            ).box.width(context.percentWidth * 18.5).make(),
            SizedBox(height: 20),
            TextFieldWithLable(
              node: discFocus,
              onSubmit: (_) {
                onSave!();
              },
              hint: 'Enter Discount',
              lable: 'Discount',
              controller: discountController,
              validateForm: (_) => InputValidation.numericValueValidation(_),
            ).box.width(context.percentWidth * 18.5).make(),
            SizedBox(height: 20),
            CustomButtonLarge(onPress: () => onSave!(), text: "Add to List"),
          ],
        ),
      ),
    );
  }
}
