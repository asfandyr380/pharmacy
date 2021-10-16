import 'package:flutter/material.dart';
import 'package:medical_store/Config/Utils/inputValidation.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Models/shelf_model.dart';
import 'package:medical_store/Views/Shelf/shelfViewModel.dart';
import 'package:medical_store/Views/Widgets/Box/box.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/PageIndicatorText/pageindicatorText.dart';
import 'package:medical_store/Views/Widgets/TextInputField/textinptfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ShelfView extends StatelessWidget {
  const ShelfView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShelfViewModel>.reactive(
      viewModelBuilder: () => ShelfViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageIndicationText(text: 'Shelf'),
            VxResponsive(
              xlarge: ShelfBoxLarge(
                formKey: model.formKey,
                mode: model.validateMode,
                save: () => model.addNewShelf(),
                shelflist: model.shelflist,
                remove: (shelf) => model.remove(shelf),
                nameController: model.nameController,
                noController: model.noController,
                isLoading: model.isLoading,
              ),
              large: ShelfBoxLarge(
                formKey: model.formKey,
                mode: model.validateMode,
                save: () => model.addNewShelf(),
                shelflist: model.shelflist,
                remove: (shelf) => model.remove(shelf),
                nameController: model.nameController,
                noController: model.noController,
                isLoading: model.isLoading,
              ),
              medium: ShelfBoxLarge(
                formKey: model.formKey,
                mode: model.validateMode,
                save: () => model.addNewShelf(),
                shelflist: model.shelflist,
                remove: (shelf) => model.remove(shelf),
                nameController: model.nameController,
                noController: model.noController,
                isLoading: model.isLoading,
              ),
              small: ShelfBoxSmall(
                formKey: model.formKey,
                mode: model.validateMode,
                save: () => model.addNewShelf(),
                shelflist: model.shelflist,
                remove: (shelf) => model.remove(shelf),
                nameController: model.nameController,
                noController: model.noController,
                isLoading: model.isLoading,
              ),
              xsmall: ShelfBoxXsmall(
                formKey: model.formKey,
                mode: model.validateMode,
                save: () => model.addNewShelf(),
                shelflist: model.shelflist,
                remove: (shelf) => model.remove(shelf),
                nameController: model.nameController,
                noController: model.noController,
                isLoading: model.isLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShelfBoxLarge extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode? mode;
  final Function? save;
  final List<ShelfModel>? shelflist;
  final Function? remove;
  final TextEditingController? nameController;
  final TextEditingController? noController;
  final bool? isLoading;
  const ShelfBoxLarge(
      {required this.formKey,
      this.mode,
      this.save,
      this.remove,
      this.shelflist,
      this.nameController,
      this.noController,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Box(
          boxContent: NewShelfContent(
            mode: mode,
            formKey: formKey,
            save: () => save!(),
            nameController: nameController,
            noController: noController,
            isLoading: isLoading,
          ),
        ),
        Box(
          boxContent: ShelfContent(
            shelflist: shelflist,
            remove: (_) => remove!(_),
          ),
        ),
      ],
    ).px20();
  }
}

class ShelfBoxSmall extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode? mode;
  final Function? save;
  final List<ShelfModel>? shelflist;
  final Function? remove;
  final TextEditingController? nameController;
  final TextEditingController? noController;
  final bool? isLoading;
  const ShelfBoxSmall(
      {required this.formKey,
      this.mode,
      this.save,
      this.remove,
      this.shelflist,
      this.nameController,
      this.noController,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Box(
          boxContent: NewShelfContent(
            mode: mode,
            formKey: formKey,
            save: () => save!(),
            nameController: nameController,
            noController: noController,
            isLoading: isLoading,
          ),
          percentWidth: 45,
        ),
        Box(
          boxContent: ShelfContent(
            shelflist: shelflist,
            remove: (_) => remove!(_),
          ),
          percentWidth: 45,
        ),
      ],
    ).px20();
  }
}

class ShelfBoxXsmall extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode? mode;
  final Function? save;
  final List<ShelfModel>? shelflist;
  final Function? remove;
  final TextEditingController? nameController;
  final TextEditingController? noController;
  final bool? isLoading;
  const ShelfBoxXsmall(
      {required this.formKey,
      this.mode,
      this.save,
      this.remove,
      this.shelflist,
      this.nameController,
      this.noController,
      this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Box(
          boxContent: NewShelfContent(
            mode: mode,
            formKey: formKey,
            save: () => save!(),
            nameController: nameController,
            noController: noController,
            isLoading: isLoading,
          ),
          percentWidth: 100,
        ),
        SizedBox(
          height: context.percentHeight * 5,
        ),
        Box(
          boxContent: ShelfContent(
            shelflist: shelflist,
            remove: (_) => remove!(_),
          ),
          percentWidth: 100,
        ),
      ],
    ).px20();
  }
}

class NewShelfContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final AutovalidateMode? mode;
  final Function? save;
  final TextEditingController? nameController;
  final TextEditingController? noController;
  final bool? isLoading;
  NewShelfContent({
    required this.formKey,
    this.mode,
    this.save,
    this.nameController,
    this.noController,
    this.isLoading,
  });

  final FocusNode noNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShelfViewModel>.reactive(
      viewModelBuilder: () => ShelfViewModel(),
      builder: (ctx, model, child) => Form(
        key: formKey,
        autovalidateMode: mode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoxHeader(
              headerTxt: "New Shelf",
            ),
            SizedBox(height: context.percentHeight * 1),
            TextFieldWithLable(
              autoFocus: true,
              lable: "Name",
              hint: "Enter Name",
              controller: nameController,
              onChange: (_) {},
              validateForm: (val) => InputValidation.emptyFieldValidation(val),
              onSubmit: (_) {
                FocusScope.of(context).requestFocus(noNode);
              },
            ),
            SizedBox(height: context.percentHeight * 3),
            TextFieldWithLable(
              lable: "Numeric Number",
              hint: "Enter Numeric Number",
              controller: noController,
              onChange: (_) {},
              validateForm: (val) =>
                  InputValidation.numericValueValidation(val),
              node: noNode,
              onSubmit: (_) {
                save!();
              },
            ),
            SizedBox(height: context.percentHeight * 3),
            CustomButtonLarge(
              onPress: () => save!(),
              isLoading: isLoading,
            )
          ],
        ).p(30),
      ),
    );
  }
}

class ShelfContent extends StatelessWidget {
  final List<ShelfModel>? shelflist;
  final Function? remove;
  const ShelfContent({this.remove, this.shelflist});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ShelfViewModel>.reactive(
      viewModelBuilder: () => ShelfViewModel(),
      builder: (ctx, model, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoxHeader(
            headerTxt: "Shelf",
          ),
          SizedBox(height: context.percentHeight * 1),
          ShelfContentTable(
            labels: ["Name", "Numericnumber", "Action"],
            data: shelflist,
            onDelete: (shelf) => remove!(shelf),
          )
        ],
      ).p(30),
    );
  }
}

class ShelfContentTable extends StatelessWidget {
  final List<String> labels;
  final List<ShelfModel>? data;
  final Function? onDelete;
  const ShelfContentTable({
    required this.labels,
    this.data,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader(
          headerLables: labels,
        ),
        for (var d in data!)
          ShelfTableData(
            name: d.name,
            numericNo: d.numericNo,
            onDelete: () => onDelete!(d),
          )
      ],
    );
  }
}

class ShelfTableData extends StatelessWidget {
  final String? name;
  final int? numericNo;
  final Function? onDelete;
  const ShelfTableData({
    this.name,
    this.numericNo,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            "$name"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * 10)
                .make(),
            Spacer(),
            "$numericNo"
                .text
                .color(textColor)
                .normal
                .make()
                .box
                .width(context.percentWidth * 10)
                .make(),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Vx.red500,
              ),
              onPressed: () => onDelete!(),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}
