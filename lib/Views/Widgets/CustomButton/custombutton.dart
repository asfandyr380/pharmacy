import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomButtonLarge extends StatelessWidget {
  final Function onPress;
  final String? text;
  final bool? isLoading;
  const CustomButtonLarge({required this.onPress, this.text, this.isLoading});

  @override
  Widget build(BuildContext context) {
    String _text = text ?? 'Submit';
    bool _isLoading = isLoading ?? false;
    return VxBox(
            child: _isLoading
                ? LoadingIndicator().centered()
                : _text.text.white.make().centered())
        .height(30)
        .width(100)
        .color(buttonColor)
        .make()
        .mouseRegion(mouseCursor: SystemMouseCursors.click)
        .onInkTap(() => onPress());
  }
}

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      width: 12,
      child: CircularProgressIndicator(
        color: Vx.white,
      ),
    );
  }
}

class NewButton extends StatelessWidget {
  final String text;
  final Function onPress;
  NewButton({required this.text, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return "$text"
        .text
        .white
        .normal
        .make()
        .centered()
        .box
        .alignCenterLeft
        .color(buttonColor)
        .height(40)
        .width(140)
        .make()
        .onInkTap(() => onPress())
        .px(context.percentWidth * 1.5)
        .py(context.percentHeight * 2);
  }
}
