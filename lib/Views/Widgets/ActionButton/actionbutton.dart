import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class ActionButton extends StatelessWidget {
  final List<String> actions;
  final Function(String?)? onChange;
  ActionButton({required this.actions, this.onChange});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      color: primaryColor,
      child: DropdownButton<String>(
        hint: 'Actions'.text.white.make(),
        onChanged: (_) => onChange!(_),
        iconEnabledColor: Vx.white,
        items: actions.map<DropdownMenuItem<String>>((e) {
          return DropdownMenuItem(
            value: e,
            child: "$e".text.make(),
          );
        }).toList(),
      ).p(5),
    );
  }
}
