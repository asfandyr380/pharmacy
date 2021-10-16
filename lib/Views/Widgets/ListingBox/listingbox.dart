import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:medical_store/Views/Widgets/Box/box.dart';
import 'package:medical_store/Views/Widgets/SearchField/searchfield.dart';
import 'package:velocity_x/velocity_x.dart';

class ListingBox extends StatelessWidget {
  final Widget boxContent;
  const ListingBox({required this.boxContent});

  @override
  Widget build(BuildContext context) {
    return VxBox(child: boxContent)
        .white
        .outerShadow
        .width(context.percentWidth * 100)
        .make()
        .px20();
  }
}

class ListingBoxContent extends StatelessWidget {
  final Widget contentWidget;
  final String? headerTxt;
  final bool? isSearchable;
  final Function? onChange;
  final Function? onSubmit;

  const ListingBoxContent({
    required this.contentWidget,
    this.headerTxt,
    this.isSearchable,
    this.onChange,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    bool _isSearchable = isSearchable ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BoxHeader(headerTxt: headerTxt),
        SizedBox(height: context.percentHeight * 3),
        SearchField(
          onChange: (_) => onChange!(_),
          onSubmit: (_) => onSubmit!(_),
        ).hide(isVisible: !_isSearchable),
        SizedBox(height: context.percentHeight * 3),
        contentWidget
      ],
    ).p(30);
  }
}

class ActionButtons extends StatelessWidget {
  final Function? onEdit;
  final Function? onAddorRemove;
  const ActionButtons({this.onAddorRemove, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.edit,
          color: Vx.white,
        )
            .box
            .p1
            .yellow500
            .makeCentered()
            .mouseRegion(mouseCursor: SystemMouseCursors.click)
            .onTap(() => onEdit!()),
        SizedBox(
          width: context.percentWidth * 1,
        ),
        Icon(
          Icons.close,
          color: Vx.white,
        )
            .box
            .red500
            .makeCentered()
            .mouseRegion(mouseCursor: SystemMouseCursors.click)
            .onTap(() => onAddorRemove!()),
      ],
    ).box.p1.width(context.percentWidth * 10).make();
  }
}

class TableItem extends StatelessWidget {
  final String itemName;
  const TableItem({required this.itemName});

  @override
  Widget build(BuildContext context) {
    return "$itemName"
        .text
        .color(textColor)
        .make()
        .box
        .width(context.percentWidth * 10)
        .make();
  }
}
