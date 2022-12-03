import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/utils/colors.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({Key? key, required this.width, required this.details})
      : super(key: key);
  final double width;
  final Map details;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          '$api/uploads/${details['uri']}',
          width: width,
          height: width,
        ),
        Positioned(
          width: width,
          bottom: 0,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: 43,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextWidget(
              text: details['name'],
              color: getwhiteOpacity(.8),
              size: 24,
              maxLines: 1,
            ),
          ),
        )
      ],
    );
  }
}
