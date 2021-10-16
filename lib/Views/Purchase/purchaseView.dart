import 'package:flutter/material.dart';
import 'package:medical_store/Views/Purchase/purchaseViewModel.dart';
import 'package:medical_store/Views/Widgets/CustomButton/custombutton.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataTableView.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class PurchaseView extends StatelessWidget {
  final Function? newPurchase;
  PurchaseView({this.newPurchase});
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PurchaseViewModel>.reactive(
      viewModelBuilder: () => PurchaseViewModel(),
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NewButton(text: 'New Purchase', onPress: () => newPurchase!()),
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
                      headerTxt: 'Purchase List',
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
