import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Views/Employes/NewEmploye/newEmployeViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';

class NewEmployeView extends StatefulWidget {
  final UserModel? employee;
  const NewEmployeView({this.employee});

  @override
  _NewEmployeViewState createState() => _NewEmployeViewState();
}

class _NewEmployeViewState extends State<NewEmployeView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewEmployeViewModel>.reactive(
      viewModelBuilder: () => NewEmployeViewModel(),
      onModelReady: (model) => model.init(widget.employee),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            PageIndicationText(text: 'New Employe'),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: NewMedicineContent(
                  nameController: model.nameController,
                  emailController: model.emailController,
                  phoneController: model.phoneController,
                  addressController1: model.addressController1,
                  addressController2: model.addressController2,
                  passwordController: model.passwordController,
                  formKey: model.formKey,
                  isLoading: model.isLoading,
                  onSubmit: () => widget.employee != null
                      ? model.updateEmployee(widget.employee)
                      : model.createEmployee(),
                ),
                headerTxt: 'New Employe',
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
  final TextEditingController? passwordController;
  final bool? isLoading;
  final GlobalKey<FormState>? formKey;
  final AutovalidateMode? mode;
  final Function? onSubmit;
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
    this.passwordController,
  });

  FocusNode emailNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode addressNode1 = FocusNode();
  FocusNode passNode = FocusNode();

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
              FocusScope.of(context).requestFocus(passNode);
            },
          ),
          SizedBox(height: 20),
          TextFieldWithLable(
            hint: 'Enter Password',
            lable: 'Password',
            controller: passwordController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
            node: passNode,
            onSubmit: (_) {
              onSubmit!();
            },
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
