import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class NewWallImageUpload extends StatelessWidget {
  const NewWallImageUpload({Key? key, required this.onPress}) : super(key: key);
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        width: 219,
        height: 300,
        // padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: getblackOpacity(.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextWidget(
              text: "Import image",
              size: 24,
              color: getblackOpacity(.5),
            ),
            const SizedBox(
              width: 31,
            ),
            Icon(
              Icons.file_download_outlined,
              size: 53,
              color: getblackOpacity(.5),
            ),
          ],
        ),
      ),
    );
  }
}
