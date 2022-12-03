import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class GeneralHeader extends StatelessWidget {
  const GeneralHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 1,
      child: Container(
        color: lightBackground,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [TextWidget(text: "Hello")],
        ),
      ),
    );
  }
}
