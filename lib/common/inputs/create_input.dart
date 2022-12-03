import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/colors.dart';

class CreateInput extends StatelessWidget {
  const CreateInput({Key? key, required this.onChange}) : super(key: key);
  final Function onChange;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 319,
          // height: 50,
          child: TextFormField(
            onChanged: (value) {
              onChange(value);
            },
            style: TextStyle(
              color: getblackOpacity(.8),
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: getblackOpacity(.3),
                ),
              ),
              fillColor: Colors.white,
            ),
            validator: (value) {
              if (value == null) {
                return "Input field required";
              } else {
                if (value.isEmpty) {
                  return "Input field required";
                } else {
                  return null;
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
