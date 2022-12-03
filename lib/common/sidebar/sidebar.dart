import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Column(
        children: const [
          TextWidget(text: "text"),
        ],
      ),
    );
  }
}
