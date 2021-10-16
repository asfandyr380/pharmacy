import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Views/Widgets/LowStockBox/lowstockViewModel.dart';
import 'package:medical_store/Views/Widgets/PaginatedDataTable/dataTableView.dart';
import 'package:medical_store/Views/Widgets/SearchField/searchfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LowStockActionButton extends StatelessWidget {
  final Function? onClose;
  const LowStockActionButton({this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {},
          color: textColor,
        ),
        IconButton(
          icon: Icon(Icons.close),
          onPressed: () => onClose!(),
          color: textColor,
        ),
      ],
    );
  }
}

class LowStockContent extends StatelessWidget {
  final Function? onClose;
  const LowStockContent({this.onClose});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LowStockViewModel>.reactive(
        viewModelBuilder: () => LowStockViewModel(),
        onModelReady: (model) => model.init(context),
        builder: (ctx, model, child) => Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "LOW STOCK MEDICINE LIST"
                        .text
                        .color(textColor)
                        .xl2
                        .normal
                        .make(),
                    LowStockActionButton(
                      onClose: () => onClose!(),
                    ),
                  ],
                ),
                SizedBox(
                  height: context.percentHeight * 2,
                ),
                SearchField(),
                SizedBox(
                  height: context.percentHeight * 2,
                ),
                ResponsiveTableView(
                  columns: model.dataColumns,
                  dataSource: model.dataSource,
                  sort: () => model.sort,
                  sortAscending: model.sortAscending,
                  sortColumnIndex: model.sortColumnIndex,
                )
              ],
            ).p(10));
  }
}

class LowStockBox extends StatelessWidget {
  final double percentWidth;
  const LowStockBox({required this.percentWidth});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LowStockViewModel>.reactive(
      viewModelBuilder: () => LowStockViewModel(),
      builder: (ctx, model, child) => VxBox(
        child: LowStockContent(
          onClose: () => model.close(),
        ),
      )
          .width(context.percentWidth * percentWidth)
          .white
          .outerShadow
          .make()
          .hide(isVisible: model.isVisible),
    );
  }
}
