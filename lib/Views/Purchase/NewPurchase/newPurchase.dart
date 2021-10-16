import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Models/product_model.dart';
import 'package:medical_store/Models/shelf_model.dart';
import 'package:medical_store/Views/Purchase/NewPurchase/newpurchaseViewModel.dart';
import 'package:medical_store/Views/Widgets/Box/box.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/SearchDropDown/searchdropdown.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class NewPurchaseView extends StatefulWidget {
  const NewPurchaseView({Key? key}) : super(key: key);

  @override
  _EditPurchaseViewState createState() => _EditPurchaseViewState();
}

class _EditPurchaseViewState extends State<NewPurchaseView> {
  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPurchaseViewModel>.reactive(
      viewModelBuilder: () => NewPurchaseViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        controller: _controller,
        child: Column(
          children: [
            SizedBox(height: 20),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: NewMedicineContent(
                  onSearch: (val) => model.searchMedicine(val),
                  onSelect: (val) => model.onMedicineSelect(val),
                  medicineController: model.medicineController,
                  quantityController: model.quantityController,
                  formkey: model.formkey,
                  mode: model.mode,
                  onSave: () => model.savetolist(),
                  productlist: model.productlist,
                  totalAmt: model.totalAmt,
                  onDelete: (m) => model.remove(m),
                  onChange: (_) {
                    model.selectedShlef = _;
                  },
                  selectedItem: model.selectedShlef,
                  shelflist: model.shelflist,
                  batchController: model.batchController,
                  savePurchase: () => model.savePurchase(),
                  noteController: model.noteController,
                  grandtotalController: model.grandTotalController,
                  isLoading: model.isLoading,
                  boxController: model.boxController,
                  buyController: model.buyingController,
                  saleController: model.saleController,
                ),
                headerTxt: 'New Purchase',
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
  final Function(String)? onSearch;
  final Function? onSelect;
  final TextEditingController? medicineController;
  final Function? onSave;
  final Function? onDelete;
  final TextEditingController? quantityController;
  final TextEditingController? batchController;
  final TextEditingController? noteController;
  final TextEditingController? grandtotalController;
  final GlobalKey<FormState> formkey;
  final AutovalidateMode mode;
  final List<ProductModel> productlist;
  final double totalAmt;
  final Function? onChange;
  final List shelflist;
  final bool isLoading;
  final Function? savePurchase;
  final TextEditingController? boxController;
  final ShelfModel? selectedItem;
  final TextEditingController? saleController;
  final TextEditingController? buyController;
  const NewMedicineContent({
    this.onSearch,
    this.onSelect,
    this.onChange,
    this.medicineController,
    this.batchController,
    this.onSave,
    this.quantityController,
    required this.formkey,
    required this.mode,
    required this.productlist,
    required this.totalAmt,
    this.onDelete,
    required this.shelflist,
    this.savePurchase,
    this.grandtotalController,
    this.noteController,
    required this.isLoading,
    this.boxController,
    this.buyController,
    this.saleController,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPurchaseViewModel>.reactive(
      viewModelBuilder: () => NewPurchaseViewModel(),
      builder: (ctx, model, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FieldRow(
            onChange: (_) => onChange!(_),
            shelflist: shelflist,
            selectedItem: selectedItem,
          ),
          SizedBox(
            height: 20,
          ),
          BoxWithLabel(
            percentWidth: 100,
            boxContent: ListingContent(
              productlist: productlist,
              totalAmt: totalAmt,
              onDelete: (_) => onDelete!(_),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ListingRow(
            onSearch: (_) => onSearch!(_),
            onSelect: (_) => onSelect!(_),
            medicineController: medicineController,
            quantityController: quantityController,
            batchController: batchController,
            formkey: formkey,
            mode: mode,
            onSave: () => onSave!(),
            boxController: boxController,
            saleController: saleController,
            buyController: buyController,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListingRowFields2(
                save: () => savePurchase!(),
                grandtotalController: grandtotalController,
                isLoading: isLoading,
              ).px(55),
            ],
          ),
        ],
      ),
    );
  }
}

class FieldRow extends StatelessWidget {
  final Function? pickDate;
  final Function? onChange;
  final List shelflist;
  final ShelfModel? selectedItem;
  const FieldRow({
    this.pickDate,
    this.onChange,
    required this.shelflist,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewPurchaseViewModel>.reactive(
      viewModelBuilder: () => NewPurchaseViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SearchDropDownHorizontal(
            selectedItem: selectedItem,
            items: shelflist,
            label: 'Shelf',
            hint: 'Select Shelf',
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
                validateForm: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListingRow extends StatelessWidget {
  final Function(String)? onSearch;
  final Function? onSelect;
  final Function? onSave;
  final TextEditingController? medicineController;
  final TextEditingController? quantityController;
  final TextEditingController? batchController;
  final GlobalKey<FormState> formkey;
  final AutovalidateMode mode;
  final TextEditingController? boxController;
  final TextEditingController? saleController;
  final TextEditingController? buyController;
  const ListingRow({
    this.onSearch,
    this.onSelect,
    this.onSave,
    this.medicineController,
    this.quantityController,
    this.batchController,
    required this.formkey,
    required this.mode,
    this.buyController,
    this.saleController,
    this.boxController,
  });

  @override
  Widget build(BuildContext context) {
    return ListingRowFields(
      onSearch: (_) => onSearch!(_),
      onSelect: (_) => onSelect!(_),
      medicineController: medicineController,
      quantityController: quantityController,
      batchController: batchController,
      formkey: formkey,
      mode: mode,
      onSave: () => onSave!(),
      boxController: boxController,
      saleController: saleController,
      buyController: buyController,
    );
  }
}

class ListingRowFields2 extends StatelessWidget {
  final Function? save;
  final TextEditingController? grandtotalController;
  final bool isLoading;
  const ListingRowFields2({
    this.save,
    this.grandtotalController,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TextFieldWithLable(
          hint: "Enter Amount",
          lable: "Grand Total",
          validateForm: (_) => InputValidation.numericValueValidation(_),
          controller: grandtotalController,
        ).box.width(context.percentWidth * 15).make(),
        SizedBox(
          height: 30,
        ),
        CustomButtonLarge(
          onPress: () => save!(),
          text: "Save Purchase",
          isLoading: isLoading,
        )
      ],
    );
  }
}

class ListingContent extends StatelessWidget {
  final List<ProductModel> productlist;
  final double totalAmt;
  final Function? onDelete;
  const ListingContent({
    required this.productlist,
    required this.totalAmt,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader2(
            headerLables: ["#", "Name", "Price", "Qty", "Amt", 'Batch No', ""],
            percentWidth: 8),
        for (var product in productlist)
          ListingTableData(
            model: product,
            onDelete: (_) => onDelete!(_),
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
  final ProductModel model;
  final Function? onDelete;
  const ListingTableData({
    required this.model,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    double _percentWidth = 8;
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
            model.name.text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.unit}"
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
            "${model.amount.toDoubleStringAsFixed()}"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * _percentWidth)
                .make(),
            Spacer(),
            "${model.batchNo}"
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
  final Function(String)? onSearch;
  final Function? onSelect;
  final Function? onSave;
  final TextEditingController? medicineController;
  final TextEditingController? quantityController;
  final TextEditingController? batchController;
  final TextEditingController? boxController;
  final TextEditingController? saleController;
  final TextEditingController? buyController;
  final GlobalKey<FormState> formkey;
  final AutovalidateMode mode;

  ListingRowFields({
    this.onSearch,
    this.onSelect,
    this.onSave,
    this.medicineController,
    this.quantityController,
    this.batchController,
    this.boxController,
    this.buyController,
    this.saleController,
    required this.formkey,
    required this.mode,
  });

  FocusNode boxNode = FocusNode();
  FocusNode qtyNode = FocusNode();
  FocusNode batchNode = FocusNode();
  FocusNode buyNode = FocusNode();
  FocusNode saleNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      autovalidateMode: mode,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SearchfieldDropDown(
                label: 'Medicine',
                hint: "Select Medicine",
                onChanged: (_) => onSearch!(_),
                onSelect: (_) {
                  onSelect!(_);
                  FocusScope.of(context).requestFocus(boxNode);
                },
                controller: medicineController,
                itemBuilder: (ctx, obj) {
                  MedicineModel medicine = obj as MedicineModel;
                  return ListTile(
                    title: Text(medicine.medicineName),
                    subtitle: '${medicine.generic}'.text.make(),
                  );
                },
                validate: (_) => InputValidation.emptyFieldValidation(_),
              ).box.width(context.percentWidth * 18.5).make(),
              TextFieldWithLable(
                hint: 'Enter Boxes',
                lable: 'Boxes',
                controller: boxController,
                validateForm: (_) => InputValidation.numericValueValidation(_),
                node: boxNode,
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(qtyNode);
                },
              ).box.width(context.percentWidth * 18.5).make(),
              TextFieldWithLable(
                hint: 'Enter Quantity',
                lable: 'Quantity',
                controller: quantityController,
                validateForm: (_) => InputValidation.numericValueValidation(_),
                node: qtyNode,
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(batchNode);
                },
              ).box.width(context.percentWidth * 18.5).make(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFieldWithLable(
                hint: 'Enter Batch No',
                lable: 'Batch No',
                controller: batchController,
                validateForm: (_) => InputValidation.emptyFieldValidation(_),
                node: batchNode,
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(buyNode);
                },
              ).box.width(context.percentWidth * 18.5).make(),
              TextFieldWithLable(
                hint: 'Enter Buying Price',
                lable: 'Buying Price',
                controller: buyController,
                validateForm: (_) => InputValidation.numericValueValidation(_),
                node: buyNode,
                onSubmit: (_) {
                  FocusScope.of(context).requestFocus(saleNode);
                },
              ).box.width(context.percentWidth * 18.5).make(),
              TextFieldWithLable(
                hint: 'Enter Selling Price',
                lable: 'Selling Price',
                controller: saleController,
                validateForm: (_) => InputValidation.numericValueValidation(_),
                node: saleNode,
                onSubmit: (_) {
                  onSave!();
                },
              ).box.width(context.percentWidth * 18.5).make(),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CustomButtonLarge(
            onPress: () => onSave!(),
            text: "Add to List",
          ),
        ],
      ),
    );
  }
}
