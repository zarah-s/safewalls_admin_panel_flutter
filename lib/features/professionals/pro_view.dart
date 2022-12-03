import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/back.dart';
import 'package:flutter_demo/common/actions/general_action_buttons.dart';
import 'package:flutter_demo/common/data/property_value.dart';
import 'package:flutter_demo/services/provider.dart';

class ProView extends StatelessWidget {
  const ProView(
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
    var userData = provider.apiData.pros.singleWhere(
      (user) => user['id'] == id,
      orElse: () => null,
    );
    bool isActive = provider.apiData.allActiveUsers
        .where(
          (element) => element['id'] == id,
        )
        .isNotEmpty;
    var walls = userData['topics'].toString().split(" ");
    var ratings = provider.apiData.ratings
        .where(
          (element) => element['proId'] == userData['id'],
        )
        .toList();
    var totalRatings = ratings
        .map(
          (e) => int.parse(e['rate'].toString()),
        )
        .reduce((value, element) => value + element);
    var ratingLength =
        ratings.length > 1 ? (ratings.length - 1) : ratings.length;
    var calRate = totalRatings / ratingLength;
    bool isSuspended = provider.apiData.banned
        .where(
          (element) => element['userId'] == id,
        )
        .isNotEmpty;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
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
            PropertyValue(property: "Username", value: userData['userName']),
            PropertyValue(
                property: "Location",
                value: '${userData['state']}, ${userData['country']}'),
            PropertyValue(
                property: "Profession", value: userData['profession']),
            PropertyValue(
                property: "Specialization", value: userData['specialization']),
            PropertyValue(property: "Walls", value: '${walls[0]}, ${walls[1]}'),
            PropertyValue(
                property: "Rating", value: calRate.toStringAsFixed(1)),
            PropertyValue(property: "Linkedin", value: userData['linkedinUrl']),
            PropertyValue(property: "Phone", value: userData['phone']),
            PropertyValue(property: "D.O.B", value: userData['dob']),
            PropertyValue(property: "Email", value: userData['email']),
            PropertyValue(property: "Gender", value: userData['gender']),
            // PropertyValue(property: "Hobby", value: userData['hobby']),
            PropertyValue(
                property: "Active Status",
                value: isActive ? "Active" : "Inactive"),
            PropertyValue(property: "Pin", value: userData['password']),
          ],
        ),
      ),
    );
  }
}
