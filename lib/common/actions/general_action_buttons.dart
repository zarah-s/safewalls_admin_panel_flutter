import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/button/action_button.dart';
import 'package:flutter_demo/utils/colors.dart';

class GeneralActionButtons extends StatelessWidget {
  const GeneralActionButtons({
    Key? key,
    required this.onActivate,
    required this.onDelete,
    required this.onMessage,
    this.isSuspended = false,
    this.trim = false,
    required this.onSuspend,
  }) : super(key: key);
  final Function onMessage;
  final Function onActivate;
  final Function onSuspend;
  final Function onDelete;
  final bool isSuspended;
  final bool trim;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 22,
      children: [
        ActionButton(
          onPress: () {
            onMessage();
          },
          color: ash,
          icon: Icons.mail_outline,
        ),
        if (!trim)
          // if (isSuspended)
          ActionButton(
            onPress: () {
              onActivate();
            },
            color: green,
            icon: CupertinoIcons.arrow_2_circlepath,
          ),
        if (!trim)
          // if (!isSuspended)
          ActionButton(
            color: orange,
            onPress: () {
              onSuspend();
            },
            icon: Icons.pause_circle_outline,
          ),
        if (trim)
          if (isSuspended)
            ActionButton(
              onPress: () {
                onActivate();
              },
              color: green,
              icon: CupertinoIcons.arrow_2_circlepath,
            )
          else
            ActionButton(
              color: orange,
              onPress: () {
                onSuspend();
              },
              icon: Icons.pause_circle_outline,
            ),
        ActionButton(
          onPress: () {
            onDelete();
          },
          color: red,
          icon: Icons.delete,
        ),
      ],
    );
  }
}
