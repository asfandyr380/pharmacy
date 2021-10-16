import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Views/Settings/settingsViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingsViewModel>.reactive(
      viewModelBuilder: () => SettingsViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          children: [
            PageIndicationText(text: 'Store Setting'),
            ListingBox(
              boxContent: ListingBoxContent(
                contentWidget: SettingsContent(
                  mode: model.mode,
                  formKey: model.formKey,
                  isLoading: model.isLoading,
                  onSave: () => model.update(),
                  nameController: model.nameController,
                  emailController: model.emailController,
                  currencyController: model.currencyController,
                  webController: model.webController,
                  phoneController: model.phoneController,
                  pNoteController: model.pNoteController,
                  sNoteController: model.sNoteController,
                  addressController: model.addressController,
                ),
                headerTxt: 'Store Setting',
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

class SettingsContent extends StatelessWidget {
  final TextEditingController? nameController;
  final TextEditingController? emailController;
  final TextEditingController? phoneController;
  final TextEditingController? webController;
  final TextEditingController? currencyController;
  final TextEditingController? pNoteController;
  final TextEditingController? sNoteController;
  final TextEditingController? addressController;
  final GlobalKey<FormState> formKey;
  final AutovalidateMode mode;
  final Function? onSave;
  final bool isLoading;
  const SettingsContent({
    required this.mode,
    required this.formKey,
    required this.isLoading,
    this.nameController,
    this.currencyController,
    this.emailController,
    this.pNoteController,
    this.phoneController,
    this.sNoteController,
    this.webController,
    this.addressController,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: mode,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: ImageBox()),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: 'Enter Name',
            lable: 'Store Name',
            controller: nameController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: '\$\$\$',
            lable: 'Currency',
            controller: currencyController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: 'example@mail.com',
            lable: 'Email',
            controller: emailController,
            validateForm: (_) => InputValidation.emailValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: 'www.example.com ',
            lable: 'Web',
            controller: webController,
            validateForm: (_) {},
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: '123-45-6789',
            lable: 'Phone',
            controller: phoneController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: 'Enter Default Note',
            lable: 'Purchase Note',
            controller: pNoteController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            hint: 'Enter Default Note',
            lable: 'Sales Note',
            controller: sNoteController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 10),
          TextFieldWithLable(
            isLarge: true,
            hint: 'Enter Shop Address',
            lable: 'Shop Address',
            controller: addressController,
            validateForm: (_) => InputValidation.emptyFieldValidation(_),
          ),
          SizedBox(height: 25),
          CustomButtonLarge(
            onPress: () => onSave!(),
            isLoading: isLoading,
            text: 'Update',
          )
        ],
      ),
    );
  }
}

class ImageBox extends StatelessWidget {
  const ImageBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        VxBox().height(200).width(235).border(color: borderColor).make(),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            VxBox(
                    child: 'Choose File'
                        .text
                        .size(context.percentWidth * 1)
                        .make()
                        .centered()
                        .p(4))
                .height(25)
                .width(110)
                .color(accentColor)
                .outerShadow
                .make()
                .mouseRegion(mouseCursor: SystemMouseCursors.click),
            SizedBox(
              width: 22,
            ),
            'No File Choose'
                .text
                .size(context.percentWidth * 1)
                .make()
                .hide(isVisible: true)
          ],
        ),
      ],
    );
  }
}
