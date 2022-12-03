import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar customAppbar(
  BuildContext context,
  Provider provider,
  showPasswordDialog,
) {
  return AppBar(
    toolbarHeight: 90,
    shadowColor: getblackOpacity(.5),
    elevation: 1.5,
    backgroundColor: lightBackground,
    title: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 98),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/logo.png',
                width: 57,
                height: 55,
              ),
              const SizedBox(
                width: 22,
              ),
              Text(
                "Safewalls",
                style: GoogleFonts.roboto(
                    color: primaryColor,
                    fontSize: 36,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundColor: Color(0XFFD9D9D9),
              ),
              const SizedBox(
                width: 15,
              ),
              DropdownButton(
                value: "Shegz",
                items: ['Shegz', 'Change Password', 'Log out']
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: TextWidget(
                          text: e.toString(),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (e) {
                  if (e == "Change Password") {
                    showPasswordDialog();
                  } else {
                    provider.logout();
                  }
                },
              ),
            ],
          )
        ],
      ),
    ),
  );
}
