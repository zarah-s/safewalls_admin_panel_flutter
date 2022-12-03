import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class PropertyValue extends StatelessWidget {
  const PropertyValue({Key? key, required this.property, required this.value})
      : super(key: key);
  final String property;
  final String value;
  @override
  Widget build(BuildContext context) {
    double max = 14;
    return ListTile(
      contentPadding: const EdgeInsets.all(0.0),
      leading: TextWidget(
        text: "$property:",
        color: getblackOpacity(.5),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: (max - property.length) * 4),
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            width: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: getblackOpacity(.3),
              ),
            ),
            child: TextWidget(
              text: value,
              color: getblackOpacity(.5),
            ),
          ),
        ],
      ),
    );
  }
}
