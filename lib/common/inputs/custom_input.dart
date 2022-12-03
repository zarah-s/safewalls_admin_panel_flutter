import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/colors.dart';

class InputField extends StatelessWidget {
  const InputField(
      {Key? key,
      required this.label,
      required this.validator,
      required this.onChange,
      this.shouldBreak = false})
      : super(key: key);
  final String label;
  final String? Function(String?) validator;
  final bool shouldBreak;
  final Function(String) onChange;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChange,
      validator: validator,
      maxLines: shouldBreak ? null : 1,
      keyboardType: shouldBreak ? TextInputType.multiline : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor,
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: getblackOpacity(.3),
          ),
        ),
      ),
    );
  }
}
