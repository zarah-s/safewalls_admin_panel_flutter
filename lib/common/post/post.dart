import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/back.dart';
import 'package:flutter_demo/common/actions/general_action_buttons.dart';
import 'package:flutter_demo/common/avatars/user_avatar.dart';
import 'package:flutter_demo/common/button/action_button.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:intl/intl.dart';

class Post extends StatelessWidget {
  const Post({
    Key? key,
    required this.onPressBack,
    this.title = '',
    this.content = '',
    this.date = '',
    this.heading = '',
    this.isHalfAction = false,
    required this.onMessage,
    required this.id,
    required this.onSuspend,
    required this.onActivate,
    required this.onDelete,
    this.isReport = false,
    this.user = const {},
  }) : super(key: key);
  final VoidCallback onPressBack;
  final String title;
  final String content;
  final String heading;
  final Map user;
  final String date;
  final String id;
  final bool isHalfAction;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  final Function(List) onDelete;
  final bool isReport;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 71,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Back(
                  label: title,
                  onPress: () {
                    onPressBack();
                  },
                ),
                if (!isReport)
                  if (isHalfAction)
                    Wrap(
                      spacing: 22,
                      children: [
                        ActionButton(
                          onPress: () {},
                          color: ash,
                          icon: Icons.mail_outline,
                        ),
                        ActionButton(
                          onPress: () {},
                          color: red,
                          icon: Icons.delete,
                        ),
                      ],
                    )
                  else
                    GeneralActionButtons(
                      onActivate: () {
                        onActivate([id]);
                      },
                      onDelete: () {
                        onDelete([id]);
                      },
                      onMessage: () {
                        onMessage([user['handle']]);
                      },
                      onSuspend: () {
                        onSuspend([id]);
                      },
                    )
              ],
            ),
            const SizedBox(
              height: 173,
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 57),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 802,
              // height: 484,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          UserAvatar(
                              avatar: user.isNotEmpty ? user['avatar'] : ""),
                          const SizedBox(
                            width: 25,
                          ),
                          TextWidget(
                            text: user.isNotEmpty ? user['userName'] : "",
                            size: 30,
                            fontWeight: FontWeight.w600,
                            color: getblackOpacity(.8),
                          ),
                        ],
                      ),
                      TextWidget(
                        text: date.isEmpty
                            ? ''
                            : DateFormat("yyyy-MM-dd")
                                .format(DateTime.parse(date)),
                        color: getblackOpacity(.5),
                        size: 20,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 39,
                  ),
                  TextWidget(
                    // maxLines: 15,
                    text: content,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
