import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class PageIndicationText extends StatelessWidget {
  final String text;

  PageIndicationText({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      child: "$text"
          .text
          .color(textColor)
          .xl2
          .normal
          .make()
          .px(context.percentWidth * 1.5)
          .py(context.percentHeight * 2),
    );
  }
}
