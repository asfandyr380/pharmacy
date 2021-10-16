import 'package:flutter/material.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Views/Reports/reportsViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ReportsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ReportsViewModel>.reactive(
      viewModelBuilder: () => ReportsViewModel(),
      onModelReady: (model) => model.init(),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.percentHeight * 3),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                isSearchable: true,
                onChange: (_) {},
                contentWidget: EmployeTableContent(
                  userlist: model.saleslist,
                  // onDelete: (_) => model.removeEmployee(_),
                  onEdit: (_) => model.update(_),
                  pageNo: model.pageNo,
                  onNext: () => model.nextPage(),
                  onPrevious: () => model.previous(),
                  isLastPage: model.lastPage,
                ),
                headerTxt: 'Reports',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmployeTableContent extends StatelessWidget {
  final List<SalesModel> userlist;
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
        TableHeader2(headerLables: [
          'Sale Code',
          "Date",
          'Grand Total',
          'Received',
          'Action'
        ]),
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
  final SalesModel model;
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
            TableItem(itemName: "${model.id}"),
            TableItem(itemName: "${model.date}"),
            TableItem(itemName: '${model.grandTotal}'),
            EditableField(
              initialValue: '${model.received}',
              onChange: (val) {
                if (val.isNotEmpty) {
                  num? value = double.tryParse(val);
                  if (value != null) {
                    model.received = value;
                  }
                }
              },
            ),
            ActionButtons(
              onEdit: () => onEdit!(model),
            )
          ],
        ),
        Divider()
      ],
    );
  }
}

class ActionButtons extends StatelessWidget {
  final Function? onEdit;

  const ActionButtons({this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.upgrade,
      color: Vx.white,
    )
        .box
        .p1
        .yellow500
        .makeCentered()
        .mouseRegion(mouseCursor: SystemMouseCursors.click)
        .onTap(() => onEdit!())
        .box
        .p1
        .width(context.percentWidth * 10)
        .make();
  }
}

class EditableField extends StatelessWidget {
  final Function(String)? onChange;
  final String initialValue;
  const EditableField({this.onChange, required this.initialValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.percentWidth * 10,
      child: TextFormField(
        onChanged: (_) => onChange!(_),
        initialValue: initialValue,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
      ),
    );
  }
}
