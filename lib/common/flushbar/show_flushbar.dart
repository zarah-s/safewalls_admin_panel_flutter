import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';

showFlushbar(Provider provider, String message, BuildContext context,
    {success = true, static = false}) {
  Flushbar(
    maxWidth: 300,
    backgroundColor: lightBackground,
    margin: const EdgeInsets.all(15.0),
    padding: const EdgeInsets.all(15.0),
    messageText: TextWidget(
      text: message,
      size: 15,
      centralized: true,
      color: success ? lightGreen : red,
    ),
    borderRadius: BorderRadius.circular(10),
    flushbarPosition: FlushbarPosition.TOP,
    duration: static ? null : const Duration(seconds: 3),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    boxShadows: const [
      BoxShadow(
        offset: Offset(15, 15),
        blurRadius: 50,
        color: Color.fromRGBO(0, 0, 0, .15),
      )
    ],
  ).show(context);
}
