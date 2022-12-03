import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/colors.dart';

class SearchInput extends StatelessWidget {
  const SearchInput(
      {Key? key, this.hintText = "Search", required this.onChanged})
      : super(key: key);
  final String hintText;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 560,
      height: 56,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: getblackOpacity(.3)),
          ),
          suffixIcon: Icon(
            Icons.search,
            color: getblackOpacity(.5),
            size: 19,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
