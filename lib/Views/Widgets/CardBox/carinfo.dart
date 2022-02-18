import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import "package:velocity_x/velocity_x.dart";

class CardInfo extends StatelessWidget {
  final num noCount;
  final String label;
  final IconData icon;
  final Color? iconColor;
  const CardInfo(
      {required this.icon,
      required this.label,
      required this.noCount,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor ?? primaryColor),
            SizedBox(
              width: context.percentWidth * 1,
            ),
            "${noCount.toStringAsFixed(2)}".text.xl2.color(iconColor ?? primaryColor).make(),
          ],
        ),
        SizedBox(
          height: context.percentHeight * 2,
        ),
        Container(
            alignment: Alignment.centerLeft,
            child: "$label".text.color(textColor).make()),
      ],
    ).px16().py12();
  }
}
