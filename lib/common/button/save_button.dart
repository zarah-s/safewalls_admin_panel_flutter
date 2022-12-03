import 'package:flutter/material.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/utils/colors.dart';

class SaveButton extends StatelessWidget {
  const SaveButton({
    Key? key,
    required this.onTap,
    this.isLoading = false,
  }) : super(key: key);
  final VoidCallback onTap;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!isLoading) {
          onTap();
        }
      },
      child: Container(
        width: 142,
        height: 53,
        decoration: BoxDecoration(
            color: lightBlue, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.save,
              size: 20,
              color: Colors.white,
            ),
            const SizedBox(
              width: 10,
            ),
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            else
              const TextWidget(
                text: "Save",
                size: 24,
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}
