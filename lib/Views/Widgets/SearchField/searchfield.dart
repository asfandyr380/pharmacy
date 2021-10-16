import 'package:flutter/material.dart';
import 'package:medical_store/Config/const.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchBox extends StatelessWidget {
  final Function? onChange;
  final Function? onSubmit;
  SearchBox({this.onChange, this.onSubmit});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 25,
      child: TextField(
        onChanged: (_) => onChange!(_),
        onSubmitted: (_) => onSubmit!(_),
        decoration: InputDecoration(
          fillColor: accentColor,
          filled: true,
          hintText: 'Search Anything',
          hintStyle: TextStyle(fontSize: 10, color: textColor),
          contentPadding: EdgeInsets.only(top: 2, left: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  final Function? onChange;
  final Function? onSubmit;
  const SearchField({this.onChange, this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        "Search:".text.xl2.normal.color(textColor).make(),
        SizedBox(width: 10),
        SearchBox(
          onChange: (_) => onChange!(_),
          onSubmit: (_) => onSubmit!(_),
        ),
      ],
    );
  }
}
