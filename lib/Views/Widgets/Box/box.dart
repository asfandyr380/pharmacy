import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter/material.dart';

class BoxHeader extends StatelessWidget {
  final String? headerTxt;
  const BoxHeader({this.headerTxt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerTxt!.text.xl3.color(textColor).make(),
        Divider(
          color: Vx.black.withOpacity(0.5),
        ),
      ],
    );
  }
}

class Box extends StatelessWidget {
  final Widget boxContent;
  final double? percentWidth;
  const Box({required this.boxContent, this.percentWidth});
  @override
  Widget build(BuildContext context) {
    double _percentWidth = percentWidth ?? 38;
    return VxBox(child: boxContent)
        .width(context.percentWidth * _percentWidth)
        .white
        .outerShadow
        .make();
  }
}

class BoxWithLabel extends StatelessWidget {
  final Widget boxContent;
  final double? percentWidth;
  const BoxWithLabel({required this.boxContent, this.percentWidth});
  @override
  Widget build(BuildContext context) {
    double _percentWidth = percentWidth ?? 50;
    return VxBox(
        child: Column(
      children: [BoxWithLableHeader(), boxContent.p(15)],
    )).width(context.percentWidth * _percentWidth).white.outerShadow.make();
  }
}

class BoxWithLableHeader extends StatelessWidget {
  const BoxWithLableHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VxBox(child: "Product List".text.white.xl2.make().p(10))
        .height(50)
        .width(context.percentWidth * 100)
        .color(primaryColor)
        .make();
  }
}
