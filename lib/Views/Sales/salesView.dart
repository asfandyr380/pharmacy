import 'package:flutter/material.dart';
import 'package:medical_store/Views/Sales/SalesViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataTableView.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SalesView extends StatelessWidget {
  final Function? newSale;
  SalesView({this.newSale});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesViewModel>.reactive(
      viewModelBuilder: () => SalesViewModel(),
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(
              text: 'New Sales',
              onPress: () => newSale!(),
            ),
            SizedBox(height: context.percentHeight * 3),
            model.dataSource != null
                ? ListingBox(
                    boxContent: ListingBoxContent(
                      onSubmit: (_) => model.searchPurchase(_, context),
                      onChange: (_) {},
                      contentWidget: model.isLoading
                          ? CircularProgressIndicator().centered()
                          : ResponsiveTableView(
                              columns: model.dataColumns,
                              dataSource: model.dataSource,
                              sort: () => model.sort,
                              sortAscending: model.sortAscending,
                              sortColumnIndex: model.sortColumnIndex,
                            ),
                      headerTxt: 'Sales List',
                    ),
                  )
                : CircularProgressIndicator().centered(),
            SizedBox(height: context.percentHeight * 3),
          ],
        ),
      ),
    );
  }
}
