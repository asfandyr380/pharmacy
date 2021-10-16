import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class TableHeader extends StatelessWidget {
  final List<String> headerLables;
  const TableHeader({required this.headerLables});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var labels in headerLables)
              labels.text.color(textColor).medium.make(),
          ],
        ),
        Divider(
          color: Vx.black.withOpacity(0.5),
        ),
      ],
    );
  }
}

class TableHeader2 extends StatelessWidget {
  final List<String> headerLables;
  final double? percentWidth;
  const TableHeader2({required this.headerLables, this.percentWidth});

  @override
  Widget build(BuildContext context) {
    double _percentWidth = percentWidth ?? 10;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (var labels in headerLables)
              labels.text
                  .color(textColor)
                  .medium
                  .make()
                  .box
                  .width(context.percentWidth * _percentWidth)
                  .make(),
          ],
        ),
        Divider(
          color: Vx.black.withOpacity(0.5),
        ),
      ],
    );
  }
}
