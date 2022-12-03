import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton(
      {Key? key,
      required this.color,
      required this.icon,
      required this.onPress})
      : super(key: key);
  final Color color;
  final IconData icon;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
