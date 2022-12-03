import 'package:flutter/material.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.ease);
    animation = Tween(begin: 1.0, end: 0.2).animate(curve);
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: FadeTransition(
          opacity: animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png'),
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
        ),
      ),
    );
  }
}
