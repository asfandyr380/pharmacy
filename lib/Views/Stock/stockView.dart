import 'package:flutter/material.dart';
import 'package:medical_store/Views/Stock/stockViewModel.dart';
import 'package:medical_store/Views/Widgets/ListingBox/listingbox.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataTableView.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class StockView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StockViewModel>.reactive(
      viewModelBuilder: () => StockViewModel(),
      onModelReady: (model) => model.init(context),
      builder: (ctx, model, child) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: context.percentHeight * 3),
            model.dataSource != null
                ? ListingBox(
                    boxContent: ListingBoxContent(
                      onSubmit: (_) => model.searchStock(_, context),
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
                      headerTxt: 'Stock List',
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
