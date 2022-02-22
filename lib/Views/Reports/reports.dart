import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Models/report_model.dart';
import 'package:medical_store/Models/sales_model.dart';
import 'package:medical_store/Views/Reports/reportsViewModel.dart';
import 'package:medical_store/Views/Widgets/CardBox/cardbox.dart';
import 'package:medical_store/Views/Widgets/CustomTableHeader/customtableheader.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/ListingBox/paginationButtons.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

import '../Widgets/SearchDropDown/searchdropdown.dart';

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CardBox(
                  widthPercent: 18,
                  icon: Icons.shopping_cart,
                  label: 'No of Purchase',
                  iconColor: Vx.green500,
                  noCount: model.purchaseCount,
                ),
                CardBox(
                  widthPercent: 18,
                  icon: Icons.money,
                  label: 'Total Purchase Amount',
                  iconColor: Vx.green500,
                  noCount: model.purchaseAmount,
                ),
                CardBox(
                  widthPercent: 18,
                  icon: Icons.shopping_basket,
                  label: 'No of Sales',
                  iconColor: Vx.green500,
                  noCount: model.salesCount,
                ),
                CardBox(
                  widthPercent: 18,
                  icon: Icons.money,
                  label: 'Total Sales Amount',
                  iconColor: Vx.green500,
                  noCount: model.salesAmt,
                ),
              ],
            ),
            SizedBox(height: 10),
            CardBox(
              widthPercent: 18,
              icon: Icons.money,
              label: 'Total Profit',
              iconColor: Vx.green500,
              noCount: model.profit,
            ).pOnly(left: 20),
            SizedBox(height: 10),
            Wrap(
              spacing: 18,
              children: [
                OutlinedButton(
                  onPressed: () => model.selectfilter("1 Month"),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(
                        model.selectedFilter == "1 Month"
                            ? Colors.white
                            : primaryColor,
                      ),
                      backgroundColor: MaterialStateProperty.all(
                        model.selectedFilter == "1 Month" ? Colors.green : null,
                      )),
                  child: Text('Month'),
                ),
                OutlinedButton(
                  onPressed: () => model.selectfilter("7 Day"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      model.selectedFilter == "7 Day"
                          ? Colors.white
                          : primaryColor,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      model.selectedFilter == "7 Day" ? Colors.green : null,
                    ),
                  ),
                  child: Text('Week'),
                ),
                OutlinedButton(
                  onPressed: () => model.selectfilter("1 Day"),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(
                      model.selectedFilter == "1 Day"
                          ? Colors.white
                          : primaryColor,
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      model.selectedFilter == "1 Day" ? Colors.green : null,
                    ),
                  ),
                  child: Text('Day'),
                ),
              ],
            ).pOnly(left: 20),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SearchDropDownHorizontal(
                  items: model.customerlist,
                  selectedItem: model.selectedCustomer,
                  label: 'Customer',
                  hint: 'Select Customer',
                  onChanged: (_) => model.selectCustomer(_),
                  validate: (_) {},
                  loadData: () => model.getCustomers(),
                ),
                Icon(Icons.close).onTap(() => model.removeCustomer()),
              ],
            ).pOnly(right: 20),
            SizedBox(height: 10),
            ListingBox(
              boxContent: ListingBoxContent(
                onSubmit: (_) {},
                isSearchable: true,
                onChange: (_) {},
                contentWidget: EmployeTableContent(
                  userlist: model.reports,
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
  final List<ReportModel> userlist;
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
          'Customer',
          "Date",
          'Debit',
          'Credit',
          'balance',
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
  final ReportModel model;
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
            TableItem(itemName: "${model.customer_Id}"),
            TableItem(itemName: "${model.date}"),
            TableItem(itemName: '${model.debit}'),
            TableItem(itemName: '${model.credit}'),
            TableItem(itemName: '${model.balance}'),
            // ActionButtons(
            //   onEdit: () => onEdit!(model),
            // )
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
