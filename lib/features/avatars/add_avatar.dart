// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

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

class AddAvatar extends StatefulWidget {
  const AddAvatar({Key? key, required this.onPressBack, required this.provider})
      : super(key: key);
  final VoidCallback onPressBack;
  final Provider provider;

  @override
  State<AddAvatar> createState() => _AddAvatarState();
}

class _AddAvatarState extends State<AddAvatar> {
  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;

  Uint8List? image;
  String header = "data:image/png;base64,";
  String? avatarTitle;
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

    setState(() {
      isLoading = true;
    });

    if (image == null) {
      showFlushbar(
        widget.provider,
        "Avatar Image Required*",
        context,
        success: false,
      );
    } else {
      var res = await ApiRequest(data: {
        'base64': _base64Data,
        'name': avatarTitle,
        'table': 'avatars'
      }, route: "adminUpload")
          .postRequest();

      // showFlushbar(widget.provider, "Here", context);
      if (res['success']) {
        showFlushbar(widget.provider, "Avatar added", context);
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
    _autoValidateMode = AutovalidateMode.disabled;
    // _formKey.currentState!.save();
    // if (!_formKey.currentState!.validate()) return;
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
              label: "Add Avatar",
              onPress: () {
                widget.onPressBack();
              },
            ),
            const SizedBox(
              height: 164,
            ),
            Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          TextWidget(
                            text: "Avatar Name: ",
                            size: 24,
                            color: getblackOpacity(.8),
                          ),
                          CreateInput(onChange: (value) {
                            setState(() {
                              avatarTitle = value;
                            });
                          })
                        ],
                      ),
                      const SizedBox(
                        width: 110,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "New Image: ",
                            size: 24,
                            color: getblackOpacity(.8),
                          ),
                          image == null
                              ? NewWallImageUpload(onPress: () {
                                  selectWallImage();
                                })
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
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SaveButton(
                      isLoading: isLoading,
                      onTap: () {
                        createNew();
                      }),
                  const SizedBox(
                    height: 100,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
