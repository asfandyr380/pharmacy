import 'package:flutter/material.dart';
import 'package:medical_store/Views/Widgets/CardBox/carinfo.dart';
import "package:velocity_x/velocity_x.dart";

class CardBox extends StatelessWidget {
  final double widthPercent;
  final num noCount;
  final String label;
  final IconData icon;
  final Color? iconColor;
  const CardBox(
      {required this.widthPercent,
      required this.icon,
      required this.label,
      required this.noCount,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: VxBox(
        child: CardInfo(
          noCount: noCount,
          label: label,
          icon: icon,
          iconColor: iconColor,
        ),
      )
          .height(context.percentHeight * 20)
          .width(context.percentWidth * widthPercent)
          .white
          .outerShadow
          .make(),
    );
  }
}
