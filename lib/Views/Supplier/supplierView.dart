import 'package:flutter/material.dart';
import 'package:medical_store/Models/users_model.dart';
import 'package:medical_store/Views/Supplier/supplierViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SupplierView extends StatelessWidget {
  final Function? newSupplier;
  final Function? editSupplier;
  SupplierView({this.newSupplier, this.editSupplier});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SupplierViewModel>.reactive(
      viewModelBuilder: () => SupplierViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(text: 'New Supplier', onPress: () => newSupplier!()),
            SizedBox(height: context.percentHeight * 3),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                onChange: (_) => model.searchCutomer(_),
                contentWidget: SupplierTableContent(
                  userlist: model.supplierlist,
                  onDelete: (_) => model.removeSupplier(_),
                  pageNo: model.pageNo,
                  onNext: () => model.nextPage(),
                  onPrevious: () => model.previous(),
                  isLastPage: model.lastPage,
                  onEdit: (m) => editSupplier!(m),
                ),
                headerTxt: 'Supplier List',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SupplierTableContent extends StatelessWidget {
  final List<UserModel> userlist;
  final Function(int)? onDelete;
  final int pageNo;
  final Function? onNext;
  final Function? onPrevious;
  final bool? isLastPage;
  final Function? onEdit;
  const SupplierTableContent({
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
          SupplierTableItems(
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

class SupplierTableItems extends StatelessWidget {
  final UserModel model;
  final Function(int)? onDelete;
  final Function? onEdit;
  const SupplierTableItems({required this.model, this.onDelete, this.onEdit});
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
