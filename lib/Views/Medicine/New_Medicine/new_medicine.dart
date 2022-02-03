import 'package:flutter/material.dart';
import 'package:medical_store/Models/medicine_model.dart';
import 'package:medical_store/Views/Medicine/New_Medicine/new_medicineViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:medical_store/Views/Widgets/SearchDropDown/searchdropdown.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';

class NewMedicineView extends StatefulWidget {
  final MedicineModel? medicine;
  const NewMedicineView({this.medicine});

  @override
  _NewMedicineViewState createState() => _NewMedicineViewState();
}

class _NewMedicineViewState extends State<NewMedicineView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewMedicineViewModel>.reactive(
      viewModelBuilder: () => NewMedicineViewModel(),
      onModelReady: (model) => model.init(widget.medicine),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            PageIndicationText(text: 'New Medicine'),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: NewMedicineContent(
                  catelist: model.catelist,
                  formkey: model.formKey,
                  mode: model.mode,
                  isLoading: model.isLoading,
                  onChange: (val) {
                    model.selectedCate = val;
                  },
                  addMedicine: () => widget.medicine != null
                      ? model.updateMedicine(widget.medicine)
                      : model.addMedicine(),
                  nameController: model.nameController,
                  genericController: model.genericController,
                  companyController: model.companyController,
                  selectedItem: model.selectedCate,
                ),
                headerTxt: 'New Medicine',
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
  final List<String> catelist;
  final Function? onChange;
  final GlobalKey<FormState> formkey;
  final AutovalidateMode mode;
  final Function? addMedicine;
  final bool? isLoading;
  final TextEditingController? nameController;
  final TextEditingController? genericController;
  final TextEditingController? companyController;
  final String? selectedItem;
  NewMedicineContent({
    required this.catelist,
    this.onChange,
    required this.formkey,
    required this.mode,
    this.addMedicine,
    this.isLoading,
    this.genericController,
    this.nameController,
    this.companyController,
    this.selectedItem,
  });

  FocusNode nameNode = FocusNode();
  FocusNode genericNode = FocusNode();
  FocusNode companyNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formkey,
      autovalidateMode: mode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SearchDropDown(
            selectedItem: selectedItem,
            items: catelist,
            hint: "Select Category",
            label: 'Category',
            onChanged: (_) {
              onChange!(_);
              FocusScope.of(context).requestFocus(nameNode);
            },
            validate: (_) => InputValidation.emptyDropdownValidation(_),
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Name',
            lable: 'Name',
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            controller: nameController,
            node: nameNode,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(genericNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Formula',
            lable: 'Generic Formula',
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            controller: genericController,
            node: genericNode,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(companyNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Company Name',
            lable: 'Company Name',
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            controller: companyController,
            node: companyNode,
            onSubmit: (_) => addMedicine!(),
          ),
          SizedBox(height: 25),
          CustomButtonLarge(
            onPress: () => addMedicine!(),
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}
