import 'package:flutter/material.dart';

class LinearButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final double vertPadding;
  final bool small;
  final double size;
  final bool bold;
  const LinearButton({
    Key? key,
    required this.text,
    this.small = false,
    this.size = 15,
    required this.onTap,
    this.bold = true,
    this.vertPadding = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: vertPadding),
        decoration: BoxDecoration(
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: [
              Color.fromRGBO(0, 255, 255, 1),
              Color.fromRGBO(51, 102, 153, 1)
            ],
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: small ? 12 : size,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
