import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/colors.dart';

SideMenuStyle customSideMenuStyle() {
  return SideMenuStyle(
    displayMode: SideMenuDisplayMode.compact,
    selectedColor: Colors.white,
    compactSideMenuWidth: 90,
    itemBorderRadius: BorderRadius.zero,
    selectedIconColor: primaryColor,
    unselectedIconColor: Colors.white,
    backgroundColor: primaryColor,
    showTooltip: true,
    itemInnerSpacing: 0.0,
    itemOuterPadding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 18),
    toggleColor: Colors.black54,
  );
}
