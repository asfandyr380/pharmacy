import 'package:flutter/material.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Views/Employes/employesViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class EmployesView extends StatelessWidget {
  final Function? newEmploye;
  final Function? editEmployee;
  const EmployesView({this.newEmploye, this.editEmployee});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EmployesViewModel>.reactive(
      viewModelBuilder: () => EmployesViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(text: 'New Employe', onPress: () => newEmploye!()),
            SizedBox(height: context.percentHeight * 3),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                onChange: (_) => model.searchEmployee(_),
                contentWidget: EmployeTableContent(
                  userlist: model.employeelist,
                  onDelete: (_) => model.removeEmployee(_),
                  pageNo: model.pageNo,
                  onNext: () => model.nextPage(),
                  onPrevious: () => model.previous(),
                  isLastPage: model.lastPage,
                  onEdit: (m) => editEmployee!(m),
                ),
                headerTxt: 'Employies List',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeTableContent extends StatelessWidget {
  final List<UserModel> userlist;
  final Function(int)? onDelete;
  final Function? onNext;
  final int pageNo;
  final Function? onPrevious;
  final bool? isLastPage;
  final Function? onEdit;

  const EmployeTableContent(
      {required this.userlist,
      this.onDelete,
      required this.pageNo,
      this.onNext,
      this.onPrevious,
      this.isLastPage,
      this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader2(headerLables: ['Name', "Email", 'Phone', 'Action']),
        for (var user in userlist)
          EmployeTableItems(
            model: user,
            onDelete: (_) => onDelete!(_),
            onEdit: (_) => onEdit!(_),
          ),
        SizedBox(
          height: context.percentHeight * 3,
        ),
        PaginationButtons(
          pageNO: pageNo,
          onNext: () => onNext!(),
          onPrevious: () => onPrevious!(),
          lastPage: isLastPage,
        )
      ],
    );
  }
}

class EmployeTableItems extends StatelessWidget {
  final UserModel model;
  final Function(int)? onDelete;
  final Function? onEdit;
  const EmployeTableItems({required this.model, this.onDelete, this.onEdit});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TableItem(itemName: model.name!),
            TableItem(itemName: model.email!),
            TableItem(itemName: '${model.phone}'),
            ActionButtons(
              onAddorRemove: () => onDelete!(model.id!),
              onEdit: () => onEdit!(model),
            )
          ],
        ),
        Divider()
      ],
    );
  }
}
