import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';

class Back extends StatelessWidget {
  const Back({Key? key, required this.onPress, required this.label})
      : super(key: key);
  final VoidCallback onPress;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            onPress();
          },
          child: const Icon(
            Icons.arrow_back,
            size: 40,
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        TextWidget(
          text: label,
          size: 40,
          fontWeight: FontWeight.w700,
        ),
      ],
    );
  }
}
