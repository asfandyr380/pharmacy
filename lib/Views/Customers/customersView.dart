import 'package:flutter/material.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Views/Customers/customersViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomerView extends StatelessWidget {
  final Function? newCustomer;
  final Function? editCustomer;
  CustomerView({this.newCustomer, this.editCustomer});

  _showDeleteDialog(BuildContext context, {required Function onConfirm}) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(_);
            },
            child: Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CustomerViewModel>.reactive(
      viewModelBuilder: () => CustomerViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(text: 'New Customer', onPress: () => newCustomer!()),
            SizedBox(height: context.percentHeight * 3),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                onChange: (_) => model.searchCutomer(_),
                contentWidget: CustomerTableContent(
                  userlist: model.customerlist,
                  onDelete: (_) => _showDeleteDialog(context, onConfirm: () => model.removeCustomer(_)),
                  pageNo: model.pageNo,
                  onNext: () => model.nextPage(),
                  onPrevious: () => model.previous(),
                  isLastPage: model.lastPage,
                  onEdit: (m) => editCustomer!(m),
                ),
                headerTxt: 'Customers List',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerTableContent extends StatelessWidget {
  final List<UserModel> userlist;
  final Function(int)? onDelete;
  final int pageNo;
  final Function? onNext;
  final Function? onPrevious;
  final bool? isLastPage;
  final Function? onEdit;

  const CustomerTableContent({
    required this.userlist,
    this.onDelete,
    required this.pageNo,
    this.onNext,
    this.onPrevious,
    this.isLastPage,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHeader2(headerLables: ['Name', "Email", 'Phone', 'Action']),
        for (var user in userlist)
          CustomerTableItems(
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

class CustomerTableItems extends StatelessWidget {
  final UserModel model;
  final Function(int)? onDelete;
  final Function? onEdit;
  const CustomerTableItems({required this.model, this.onDelete, this.onEdit});
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
                onEdit: () => onEdit!(model))
          ],
        ),
        Divider()
      ],
    );
  }
}
