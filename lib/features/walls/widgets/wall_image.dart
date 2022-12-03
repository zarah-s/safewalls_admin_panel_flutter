import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:get/get.dart';

class WallImage extends StatefulWidget {
  const WallImage({
    Key? key,
    required this.onPress,
    required this.width,
    required this.details,
    required this.onActivate,
    required this.onDelete,
    required this.onSuspend,
  }) : super(key: key);
  final Function(String) onPress;
  final double width;
  final Map details;
  final Function(Map) onDelete;
  final Function(String) onSuspend;
  final Function(String) onActivate;
  @override
  State<WallImage> createState() => _WallImageState();
}

class _WallImageState extends State<WallImage> {
  bool _isActive = false;
  @override
  Widget build(BuildContext context) {
    // print(widget.details);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: widget.width,
            height: widget.width + 131,
            decoration: BoxDecoration(
              border: _isActive
                  ? widget.details['suspended'] == 'false'
                      ? Border.all(color: orange, width: 5)
                      : Border.all(color: green, width: 5)
                  : null,
              // borderRadius: BorderRadius.circular(25),
            ),
            foregroundDecoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black87
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0, .2, 1],
              ),
            ),
            child: InkWell(
              onLongPress: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const TextWidget(
                    text: "Confirm Delete",
                    size: 25,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const TextWidget(text: "Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onDelete(widget.details);
                        Get.back(closeOverlays: true);
                        // Navigator.of(context).pop(true);
                      },
                      child: TextWidget(
                        text: "Delete",
                        color: red,
                      ),
                    )
                  ],
                ),
              ),
              onTap: () {
                widget.onPress(widget.details['id']);
              },
              onHover: (value) {
                setState(() {
                  _isActive = value;
                });
              },
              child: Image.network(
                '$api/uploads/${widget.details['banner']}',
                width: widget.width,
                height: widget.width + 131,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        if (_isActive)
          Positioned(
            top: -10,
            right: -10,
            child: InkWell(
              onTap: () {
                if (widget.details['suspended'] == 'false') {
                  widget.onSuspend(widget.details['id']);
                } else {
                  widget.onActivate(widget.details['id']);
                }
              },
              child: widget.details['suspended'] == 'false'
                  ? Icon(
                      Icons.pause_circle,
                      color: orange,
                    )
                  : Icon(
                      CupertinoIcons.arrow_2_circlepath_circle_fill,
                      color: green,
                    ),
            ),
          ),
        Positioned(
          width: widget.width,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.all(34),
            child: TextWidget(
              text: widget.details['title'],
              color: Colors.white,
              fontWeight: FontWeight.w700,
              size: 40,
              maxLines: 3,
            ),
          ),
        )
      ],
    );
  }
}
