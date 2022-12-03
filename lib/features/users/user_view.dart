import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/back.dart';
import 'package:flutter_demo/common/actions/general_action_buttons.dart';
import 'package:flutter_demo/common/data/property_value.dart';
import 'package:flutter_demo/services/provider.dart';

class UserView extends StatelessWidget {
  const UserView(
      {Key? key,
      required this.onPressBack,
      required this.id,
      required this.onMessage,
      required this.onSuspend,
      required this.onActivate,
      required this.provider})
      : super(key: key);
  final VoidCallback onPressBack;
  final Provider provider;
  final String id;
  final Function(List) onMessage;
  final Function(List) onActivate;
  final Function(List) onSuspend;
  @override
  Widget build(BuildContext context) {
    // print(id);

    var userData =
        provider.apiData.users.singleWhere((user) => user['id'] == id);
    bool isActive = provider.apiData.allActiveUsers
        .where(
          (element) => element['id'] == id,
        )
        .isNotEmpty;

    bool isSuspended = provider.apiData.banned
        .where(
          (element) => element['userId'] == id,
        )
        .isNotEmpty;
    // print(userData);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Back(
                  label: userData['handle'],
                  onPress: () {
                    onPressBack();
                  },
                ),
                GeneralActionButtons(
                  trim: true,
                  isSuspended: isSuspended,
                  onActivate: () {
                    onActivate([
                      {'seeAll': userData['id']}
                    ]);
                  },
                  onDelete: () {},
                  onMessage: () {
                    onMessage([
                      {'seeAll': userData['id']}
                    ]);
                  },
                  onSuspend: () {
                    onSuspend([
                      {'seeAll': userData['id']}
                    ]);
                  },
                )
              ],
            ),
            const SizedBox(
              height: 164,
            ),
            PropertyValue(property: "Nickname", value: userData['handle']),
            PropertyValue(property: "username", value: userData['userName']),
            PropertyValue(
                property: "Location",
                value: '${userData['state']}, ${userData['country']}'),
            PropertyValue(property: "Phone", value: userData['phone']),
            PropertyValue(property: "D.O.B", value: userData['dob']),
            PropertyValue(property: "Email", value: userData['email']),
            PropertyValue(property: "Gender", value: userData['gender']),
            PropertyValue(property: "Hobby", value: userData['hobby']),
            PropertyValue(
                property: "Active status",
                value: isActive ? "Active" : "Inactive"),
            PropertyValue(property: "Pin", value: userData['password']),
          ],
        ),
      ),
    );
  }
}
