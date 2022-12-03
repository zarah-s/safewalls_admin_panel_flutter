import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class NewButton extends StatelessWidget {
  const NewButton({Key? key, required this.text, required this.onTap})
      : super(key: key);
  final String text;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        alignment: Alignment.center,
        width: 214,
        height: 64,
        decoration: BoxDecoration(
          color: lightGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.add,
              color: Colors.white,
              size: 35,
            ),
            TextWidget(
              text: text,
              size: 32,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}
