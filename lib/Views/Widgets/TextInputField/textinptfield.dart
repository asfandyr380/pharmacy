import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class TextFieldWithLable extends StatelessWidget {
  final String lable;
  final String hint;
  final Function? onChange;
  final Function? validateForm;
  final bool? isLarge;
  final TextEditingController? controller;
  final FocusNode? node;
  final Function? onSubmit;
  final bool? autoFocus;
  const TextFieldWithLable({
    required this.hint,
    required this.lable,
    this.onChange,
    this.validateForm,
    this.isLarge,
    this.controller,
    this.node,
    this.onSubmit,
    this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    bool _isLarge = isLarge ?? false;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        lable.text.color(textColor).normal.make(),
        SizedBox(height: context.percentHeight * 1),
        TextInputField(
          isLarge: _isLarge,
          controller: controller,
          hint: hint,
          node: node,
          autoFocus: autoFocus,
          onSubmit: (_) {
            onSubmit!(_);
          },
          validateForm: (_) {
            validateForm!(_);
          },
        ),
      ],
    );
  }
}

class TextFieldWithLableHorizontal extends StatelessWidget {
  final String lable;
  final String hint;
  final Function? onChange;
  final Function? validateForm;
  final bool? isLarge;
  final bool? readOnly;
  final String? initialValue;
  final TextEditingController? controller;
  const TextFieldWithLableHorizontal({
    required this.hint,
    required this.lable,
    this.controller,
    this.onChange,
    this.validateForm,
    this.isLarge,
    this.readOnly,
    this.initialValue,
  });

  @override
  Widget build(BuildContext context) {
    bool _readOnly = readOnly ?? false;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        '$lable :'.text.color(textColor).xl.normal.make(),
        SizedBox(width: context.percentWidth * 1),
        TextInputField(
          hint: hint,
          controller: controller,
          readOnly: _readOnly,
          initialValue: initialValue,
          onChange: (_) {
            onChange!(_);
          },
          validateForm: (_) {
            validateForm!(_);
          },
        ).box.width(context.percentWidth * 15).make(),
      ],
    );
  }
}

class TextInputField extends StatelessWidget {
  final String? hint;
  final Function? onChange;
  final Function? validateForm;
  final bool? readOnly;
  final String? initialValue;
  final bool? isLarge;
  final TextEditingController? controller;
  final FocusNode? node;
  final Function? onSubmit;
  final bool? autoFocus;
  TextInputField(
      {this.hint,
      this.onChange,
      this.validateForm,
      this.readOnly,
      this.controller,
      this.initialValue,
      this.node,
      this.onSubmit,
      this.autoFocus,
      this.isLarge});

  @override
  Widget build(BuildContext context) {
    bool _readOnly = readOnly ?? false;
    bool _isLarge = isLarge ?? false;
    bool _autoFocus = autoFocus ?? false;
    return Container(
      child: TextFormField(
        onFieldSubmitted: (_) {
          onSubmit!(_);
        },
        autofocus: _autoFocus,
        focusNode: node,
        controller: controller,
        validator: (_) => validateForm!(_),
        keyboardType: TextInputType.multiline,
        maxLines: _isLarge ? 7 : 1,
        minLines: _isLarge ? null : 1,
        readOnly: _readOnly,
        initialValue: initialValue,
        decoration: InputDecoration(
          fillColor: accentColor,
          filled: true,
          hintText: "$hint",
          hintStyle: TextStyle(fontSize: 15, color: textColor),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Vx.black.withOpacity(0.2),
            ),
          ),
        ),
      ),
    );
  }
}
