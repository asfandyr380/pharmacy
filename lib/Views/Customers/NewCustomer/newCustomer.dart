import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Views/Customers/NewCustomer/newCustomerViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';

class NewCustomer extends StatefulWidget {
  final UserModel? customer;
  const NewCustomer({this.customer});

  @override
  _NewCustomerViewState createState() => _NewCustomerViewState();
}

class _NewCustomerViewState extends State<NewCustomer> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewCustomerViewModel>.reactive(
      viewModelBuilder: () => NewCustomerViewModel(),
      onModelReady: (model) => model.init(widget.customer),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            PageIndicationText(text: 'New Customer'),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: NewMedicineContent(
                  nameController: model.nameController,
                  emailController: model.emailController,
                  phoneController: model.phoneController,
                  addressController1: model.addressController1,
                  addressController2: model.addressController2,
                  formKey: model.formKey,
                  isLoading: model.isLoading,
                  onSubmit: () => widget.customer != null
                      ? model.updateCustomer(widget.customer)
                      : model.createCustomer(),
                  lisenceController: model.lisenceController,
                  dateController: model.dateController,
                  selectDate: (ctx) => model.selectDate(ctx),
                ),
                headerTxt: 'New Customer',
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
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? addressController1;
  final TextEditingController? addressController2;
  final TextEditingController? dateController;
  final TextEditingController? lisenceController;
  final bool? isLoading;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode? mode;
  final Function? onSubmit;
  final Function? selectDate;
  NewMedicineContent({
    this.addressController1,
    this.addressController2,
    this.emailController,
    this.formKey,
    this.isLoading,
    this.mode,
    this.nameController,
    this.phoneController,
    this.onSubmit,
    this.dateController,
    this.lisenceController,
    this.selectDate,
  });

  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode addressNode1 = FocusNode();
  FocusNode lisenceNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: mode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFieldWithLable(
            autoFocus: true,
            hint: 'Enter Name',
            lable: 'Name',
            controller: nameController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(emailNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Email',
            lable: 'Email',
            controller: emailController,
            validateForm: (_) => InputValidation.emailValidation(_),
            node: emailNode,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(phoneNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Phone Number',
            lable: 'Phone',
            controller: phoneController,
            validateForm: (_) => InputValidation.numericValueValidation(_),
            node: phoneNode,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(addressNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Address',
            lable: 'Address',
            controller: addressController1,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            node: addressNode,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(addressNode1);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Address (Optional)',
            lable: 'Address',
            controller: addressController2,
            validateForm: (_) {},
            node: addressNode1,
            onSubmit: (_) {
              FocusScope.of(context).requestFocus(lisenceNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Lisence No',
            lable: 'Lisence Number',
            controller: lisenceController,
            validateForm: (_) => InputValidation.numericValueValidation(_),
            node: lisenceNode,
            onSubmit: (_) {
              selectDate!(context);
            },
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => selectDate!(context),
            child: AbsorbPointer(
              child: TextFieldWithLableHorizontal(
                hint: "Select Date",
                lable: "Expire Date",
                readOnly: true,
                controller: dateController,
                validateForm: (_) {},
              ),
            ),
          ),
          SizedBox(height: 25),
          CustomButtonLarge(
            onPress: () => onSubmit!(),
            isLoading: isLoading,
          )
        ],
      ),
    );
  }
}
