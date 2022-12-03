// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_demo/common/button/save_button.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/services/post_request.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class Policy extends StatefulWidget {
  const Policy({Key? key, required this.provider}) : super(key: key);
  final Provider provider;
  @override
  State<Policy> createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
  late TextEditingController _controller;
  late String description;

  Future<void> saveTerm() async {
    showFlushbar(widget.provider, "Loading...", context, static: true);
    var res = await ApiRequest(data: {'term': description}, route: 'terms')
        .postRequest();

    if (res['success']) {
      Get.back(closeOverlays: true);

      showFlushbar(widget.provider, "Saved", context);
    } else {
      Get.back(closeOverlays: true);

      showFlushbar(widget.provider, res['msg'], context, success: false);
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    description = widget.provider.apiData.terms;
  }

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
            TextWidget(
              text: "POLICY",
              size: 40,
              fontWeight: FontWeight.w700,
              color: getblackOpacity(.8),
            ),
            const SizedBox(
              height: 64,
            ),
            TextWidget(
              text: "Terms and Conditions",
              size: 32,
              fontWeight: FontWeight.w600,
              color: getblackOpacity(.5),
            ),
            const SizedBox(
              height: 91,
            ),
            MarkdownTextInput(
              (String value) => setState(() => description = value),
              description,
              label: 'Terms and conditions',
              maxLines: 10,
              actions: MarkdownType.values,
              controller: _controller,
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: MarkdownBody(
                        data: description,
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                );
              },
              child: const TextWidget(text: "Preview?"),
            ),
            const SizedBox(
              height: 54,
            ),
            SaveButton(
              onTap: () {
                saveTerm();
              },
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
