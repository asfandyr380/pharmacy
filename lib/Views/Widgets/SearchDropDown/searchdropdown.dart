import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchDropDown extends StatelessWidget {
  final List<String> items;
  final String label;
  final String? hint;
  final Function? validate;
  final Function? onChanged;
  final String? selectedItem;
  const SearchDropDown({
    this.hint,
    required this.items,
    required this.label,
    this.validate,
    this.onChanged,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.text.color(textColor).normal.make(),
        SizedBox(height: context.percentHeight * 1),
        DropdownSearch<String>(
          selectedItem: selectedItem,
          validator: (_) => validate!(_),
          mode: Mode.MENU,
          showSearchBox: true,
          items: items,
          hint: hint,
          onChanged: (_) => onChanged!(_),
          dropdownSearchDecoration: InputDecoration(
            fillColor: accentColor,
            filled: true,
            hintStyle: TextStyle(fontSize: 15, color: textColor),
            contentPadding: EdgeInsets.only(bottom: 10, left: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Vx.black.withOpacity(0.2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SearchDropDownHorizontal extends StatelessWidget {
  final List<dynamic> items;
  final String label;
  final String? hint;
  final Function? validate;
  final Function? onChanged;
  final dynamic selectedItem;
  const SearchDropDownHorizontal({
    this.hint,
    required this.items,
    required this.label,
    this.onChanged,
    this.validate,
    this.selectedItem,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        '$label :'.text.color(textColor).xl.normal.make(),
        SizedBox(width: context.percentWidth * 1),
        DropdownSearch<dynamic>(
          selectedItem: selectedItem,
          validator: (_) => validate!(_),
          mode: Mode.MENU,
          showSearchBox: true,
          items: items,
          hint: hint,
          itemAsString: (_) => '${_.name}',
          onChanged: (_) => onChanged!(_),
          dropdownSearchDecoration: InputDecoration(
            fillColor: accentColor,
            filled: true,
            hintStyle: TextStyle(fontSize: 15, color: textColor),
            contentPadding: EdgeInsets.only(bottom: 10, left: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Vx.black.withOpacity(0.2),
              ),
            ),
          ),
        ).box.width(context.percentWidth * 15).make(),
      ],
    );
  }
}

class SearchfieldDropDown extends StatelessWidget {
  final String label;
  final String? hint;
  final Function? validate;
  final Function? onChanged;
  final Function? onSelect;
  final Function(BuildContext, Object?) itemBuilder;
  final TextEditingController? controller;
  final Function? onSubmit;
  const SearchfieldDropDown({
    this.hint,
    required this.label,
    this.validate,
    this.onChanged,
    this.controller,
    this.onSelect,
    this.onSubmit,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label.text.color(textColor).normal.make(),
        SizedBox(height: context.percentHeight * 1),
        TypeAheadFormField(
          validator: (_) => validate!(_),
          textFieldConfiguration: TextFieldConfiguration(
            onSubmitted: (_) => onSubmit!(_),
            controller: controller,
            decoration: InputDecoration(
              fillColor: accentColor,
              filled: true,
              hintText: hint,
              hintStyle: TextStyle(fontSize: 15, color: textColor),
              contentPadding: EdgeInsets.only(bottom: 10, left: 10),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Vx.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
          onSuggestionSelected: (selected) => onSelect!(selected),
          itemBuilder: (context, suggestion) =>
              itemBuilder(context, suggestion),
          suggestionsCallback: (pattern) async {
            return await onChanged!(pattern);
          },
        )
      ],
    );
  }
}
