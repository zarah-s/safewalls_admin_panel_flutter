import 'package:flutter/material.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/utils/colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key, required this.avatar}) : super(key: key);
  final String avatar;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 51,
      backgroundColor: active,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: NetworkImage(
          '$api/uploads/$avatar',
        ),
        radius: 49,
      ),
    );
  }
}
