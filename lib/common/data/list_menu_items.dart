import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';

class Items {
  Items(
      {required this.page,
      required this.onTap,
      required this.pageIndex,
      required this.provider});
  final PageController page;
  final Function onTap;
  final Provider provider;
  final int pageIndex;
  getList<List>() {
    var short = provider.apiData;
    bool usersBadge = short.users
        .where((element) => element['seen'].toString() == '0')
        .isNotEmpty;

    bool prosBadge = short.pros
        .where((element) => element['seen'].toString() == '0')
        .isNotEmpty;

    bool verificationBadge = short.verificationRequest.isNotEmpty;

    bool reportsBadge = short.reports
        .where((element) => element['seen'].toString() == '0')
        .isNotEmpty;

    bool testimoniesBadge = short.testimonies
        .where((element) => element['seen'].toString() == '0')
        .isNotEmpty;

    bool promotionsBadge = short.promotes
        .where((element) => element['seen'].toString() == '0')
        .isNotEmpty;

    return [
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 0,
        title: 'Dashboard',
        onTap: () {
          page.jumpToPage(0);
          onTap(0);
        },
        builder: (context, displayMode) => Center(
          child: Image.asset(
            'assets/dashboard.png',
            color: pageIndex == 0 ? primaryColor : Colors.white,
            width: 37.79,
            height: 40,
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 1,
        title: 'Users',
        onTap: () {
          page.jumpToPage(1);
          onTap(1);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/users.png',
                color: pageIndex == 1 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (usersBadge) badge()
            ],
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 2,
        title: 'Professionals',
        onTap: () {
          page.jumpToPage(2);
          onTap(2);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/pros.png',
                color: pageIndex == 2 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (prosBadge) badge()
            ],
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 3,
        title: 'Walls',
        onTap: () {
          page.jumpToPage(3);
          onTap(3);
        },
        builder: (context, displayMode) => Center(
          child: Image.asset(
            'assets/walls.png',
            color: pageIndex == 3 ? primaryColor : Colors.white,
            width: 37.79,
            height: 40,
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 4,
        title: 'Avatars',
        onTap: () {
          page.jumpToPage(4);
          onTap(4);
        },
        builder: (context, displayMode) => Center(
          child: Image.asset(
            'assets/avatars.png',
            color: pageIndex == 4 ? primaryColor : Colors.white,
            width: 37.79,
            height: 40,
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 5,
        title: 'Reports',
        onTap: () {
          page.jumpToPage(5);
          onTap(5);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/reports.png',
                color: pageIndex == 5 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (reportsBadge) badge()
            ],
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 6,
        title: 'Policy',
        onTap: () {
          page.jumpToPage(6);
          onTap(6);
        },
        builder: (context, displayMode) => Center(
          child: Image.asset(
            'assets/policy.png',
            color: pageIndex == 6 ? primaryColor : Colors.white,
            width: 37.79,
            height: 40,
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 7,
        title: 'Testimonies',
        onTap: () {
          page.jumpToPage(7);
          onTap(7);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/testimonies.png',
                color: pageIndex == 7 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (testimoniesBadge) badge()
            ],
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 8,
        title: 'Promotions',
        onTap: () {
          page.jumpToPage(8);
          onTap(8);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/promotions.png',
                color: pageIndex == 8 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (promotionsBadge) badge()
            ],
          ),
        ),
      ),
      SideMenuItem(
        // Priority of item to show on SideMenu, lower value is displayed at the top
        priority: 9,
        title: 'Verificatio Request',
        onTap: () {
          page.jumpToPage(9);
          onTap(9);
        },
        builder: (context, displayMode) => Center(
          child: Stack(
            children: [
              Image.asset(
                'assets/pro_verified.png',
                color: pageIndex == 9 ? primaryColor : Colors.white,
                width: 37.79,
                height: 40,
              ),
              if (verificationBadge) badge()
            ],
          ),
        ),
      ),
    ];
  }

  Positioned badge() {
    return Positioned(
      top: 0,
      right: 0,
      child: CircleAvatar(
        backgroundColor: red,
        radius: 4,
      ),
    );
  }
}
