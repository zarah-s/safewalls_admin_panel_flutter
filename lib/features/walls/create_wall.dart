// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
// import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/common/actions/back.dart';
import 'package:flutter_demo/common/button/save_button.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/inputs/create_input.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/features/walls/widgets/new_image_upload.dart';
import 'package:flutter_demo/services/file_picker.dart';
import 'package:flutter_demo/services/post_request.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

// import 'package:simple_markdown_editor/simple_markdown_editor.dart';

class CreateWall extends StatefulWidget {
  const CreateWall(
      {Key? key, required this.onPressBack, required this.provider})
      : super(key: key);
  final Function onPressBack;
  final Provider provider;
  @override
  State<CreateWall> createState() => _CreateWallState();
}

class _CreateWallState extends State<CreateWall> {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  late TextEditingController _controller;
  String description = '';
  Uint8List? image;
  String header = "data:image/png;base64,";
  String? wallTitle;
  String? _base64Data;
  bool isLoading = false;

  Future selectWallImage() async {
    var res = await CustomFilePicker.pickFile();

    if (res != null) {
      setState(() {
        image = res.files.single.bytes;
        _base64Data = header + base64Encode(res.files.single.bytes!.cast());
      });
    }
  }

  Future<void> createNew() async {
    _formKey.currentState!.save();

    setState(() {
      _autoValidateMode = AutovalidateMode.always;
    });

    if (!_formKey.currentState!.validate()) return;

    if (image == null) {
      showFlushbar(
        widget.provider,
        "Wall Image Required*",
        context,
        success: false,
      );
    } else if (description.isEmpty) {
      showFlushbar(
        widget.provider,
        "Wall Desc Required*",
        context,
        success: false,
      );
    } else {
      setState(() {
        isLoading = true;
      });
      var res = await ApiRequest(data: {
        'base64': _base64Data,
        'title': wallTitle,
        'rules': description,
        'table': 'walls'
      }, route: "adminUpload")
          .postRequest();

      // showFlushbar(widget.provider, "Here", context);
      if (res['success']) {
        showFlushbar(widget.provider, "Wall added", context);
        widget.onPressBack();
      } else {
        showFlushbar(widget.provider, res['msg'], context, success: false);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _autoValidateMode = AutovalidateMode.disabled;
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
              height: 70,
            ),
            Back(
              label: "Create Wall",
              onPress: () {
                widget.onPressBack();
              },
            ),
            const SizedBox(
              height: 164,
            ),
            Form(
              autovalidateMode: _autoValidateMode,
              key: _formKey,
              child: Column(
                children: [
                  ListTile(
                    leading: TextWidget(
                      text: "Wall Name: ",
                      size: 24,
                      color: getblackOpacity(.8),
                    ),
                    title: CreateInput(
                      onChange: (e) {
                        setState(() {
                          wallTitle = e;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 112,
                  ),
                  ListTile(
                    leading: TextWidget(
                      text: "Wall Image: ",
                      size: 24,
                      color: getblackOpacity(.8),
                    ),
                    title: Row(
                      children: [
                        image == null
                            ? NewWallImageUpload(
                                onPress: () {
                                  selectWallImage();
                                  // getMultipleImageInfos();
                                  // MediaType
                                  // _startFilePicker();
                                },
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(
                                      image!,
                                      width: 219,
                                      height: 300,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    right: 10,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          image = null;
                                          _base64Data = null;
                                        });
                                      },
                                      child: Icon(
                                        Icons.cancel,
                                        color: red,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 140,
            ),
            TextWidget(
              text: "Wall Description",
              size: 24,
              color: getblackOpacity(.8),
            ),
            const SizedBox(
              height: 55,
            ),

            MarkdownTextInput(
              (String value) => setState(() => description = value),
              description,
              label: 'Wall Description',
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
              height: 64,
            ),
            SaveButton(
              isLoading: isLoading,
              onTap: () {
                createNew();
              },
            ),
            const SizedBox(
              height: 100,
            )

            // PropertyValue(property: "property", value: value)
          ],
        ),
      ),
    );
  }
}
