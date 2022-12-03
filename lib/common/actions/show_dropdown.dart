import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class ShowDropdown extends StatelessWidget {
  const ShowDropdown({
    Key? key,
    required this.initial,
    required this.items,
    required this.onChange,
  }) : super(key: key);
  final String initial;
  final List<String> items;
  final Function onChange;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 133,
      height: 56,
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: getblackOpacity(.3)),
          ),
        ),
        value: initial,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: TextWidget(
                  text: e,
                ),
              ),
            )
            .toList(),
        onChanged: (e) {
          onChange(e);
        },
      ),
    );
  }
}
