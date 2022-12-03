import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key? key,
    required this.text,
    this.centralized = false,
    this.color = Colors.black,
    this.fontWeight = FontWeight.w400,
    this.maxLines = 200,
    this.size = 13,
  }) : super(key: key);
  final String text;
  final double size;
  final FontWeight fontWeight;
  final bool centralized;
  final Color color;
  final dynamic maxLines;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontWeight: fontWeight, fontSize: size),
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      textAlign: centralized ? TextAlign.center : TextAlign.start,
    );
  }
}
