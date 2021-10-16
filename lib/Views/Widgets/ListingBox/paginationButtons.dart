import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class PaginationButtons extends StatelessWidget {
  final int pageNO;
  final Function? onNext;
  final Function? onPrevious;
  final bool? lastPage;
  PaginationButtons(
      {required this.pageNO, this.onNext, this.onPrevious, this.lastPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        VxBox(child: 'Previous'.text.color(textColor).make().p(5).centered())
            .border(color: Vx.black.withOpacity(0.5))
            .white
            .make()
            .mouseRegion(mouseCursor: SystemMouseCursors.click)
            .onTap(() => onPrevious!())
            .hide(isVisible: pageNO == 1 ? false : true),
        VxBox(child: '$pageNO'.text.white.make().py(5).px(10).centered())
            .border(color: Vx.black.withOpacity(0.5))
            .color(buttonColor)
            .make(),
        VxBox(child: 'Next'.text.color(textColor).make().p(5).centered())
            .border(color: Vx.black.withOpacity(0.5))
            .white
            .make()
            .mouseRegion(mouseCursor: SystemMouseCursors.click)
            .onTap(() => onNext!())
            .hide(isVisible: !lastPage!),
      ],
    );
  }
}
