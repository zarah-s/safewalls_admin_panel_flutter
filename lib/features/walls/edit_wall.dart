// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo/common/actions/back.dart';
import 'package:flutter_demo/common/button/action_button.dart';
import 'package:flutter_demo/common/button/save_button.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/features/walls/widgets/new_image_upload.dart';
import 'package:flutter_demo/services/api.dart';
import 'package:flutter_demo/services/file_picker.dart';
import 'package:flutter_demo/services/post_request.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown_editable_textinput/format_markdown.dart';
import 'package:markdown_editable_textinput/markdown_text_input.dart';

class EditWall extends StatefulWidget {
  const EditWall({
    Key? key,
    required this.onPressBack,
    required this.id,
    required this.provider,
    required this.onActivate,
    required this.onDelete,
    required this.onSuspend,
  }) : super(key: key);
  final VoidCallback onPressBack;
  final String id;
  final Provider provider;
  final Function(Map) onDelete;
  final Function(String) onSuspend;
  final Function(String) onActivate;
  @override
  State<EditWall> createState() => _EditWallState();
}

class _EditWallState extends State<EditWall> {
  late String _id;
  late Provider _provider;

  final _formKey = GlobalKey<FormState>();
  late AutovalidateMode _autoValidateMode;
  late TextEditingController _controller;
  String description = '';
  Uint8List? image;
  String header = "data:image/png;base64,";
  String? wallTitle;
  String? _base64Data;
  bool isLoading = false;
  late FocusNode _focusNode;

  Future selectWallImage() async {
    var res = await CustomFilePicker.pickFile();

    if (res != null) {
      setState(() {
        image = res.files.single.bytes!;
        _base64Data = header + base64Encode(res.files.single.bytes!.cast());
      });
    }
  }

  Future<void> editWall() async {
    _formKey.currentState!.save();

    setState(() {
      isLoading = true;
    });
    var res = await ApiRequest(data: {
      'base64': _base64Data,
      'title': wallTitle,
      'rules': description,
      'id': widget.id
    }, route: "editWall")
        .postRequest();

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

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _autoValidateMode = AutovalidateMode.always;
    _focusNode = FocusNode();
    _id = widget.id;
    _provider = widget.provider;
    wallTitle = _provider.apiData.walls
        .singleWhere((element) => element['id'] == _id)['title'];
    description = _provider.apiData.walls
        .singleWhere((element) => element['id'] == _id)['rules'];
    // _formKey.currentState!.save();
    // if (!_formKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {
    Map details =
        _provider.apiData.walls.singleWhere((element) => element['id'] == _id);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 71,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Back(
                  label: "Edit Wall",
                  onPress: () {
                    widget.onPressBack();
                  },
                ),
                Wrap(
                  spacing: 22,
                  children: [
                    if (details['suspended'] == 'true')
                      ActionButton(
                        onPress: () {
                          widget.onActivate(details['id']);
                        },
                        color: green,
                        icon: CupertinoIcons.arrow_2_circlepath,
                      )
                    else
                      ActionButton(
                        onPress: () {
                          widget.onSuspend(details['id']);
                        },
                        color: orange,
                        icon: Icons.pause,
                      ),
                    ActionButton(
                      onPress: () {
                        widget.onDelete(details);
                        widget.onPressBack();
                      },
                      color: red,
                      icon: Icons.delete,
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 173,
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
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 319,
                          // height: 50,
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                wallTitle = value;
                              });
                            },
                            // ed: _isFieldEnabled,
                            focusNode: _focusNode,
                            initialValue: details['title'],
                            style: TextStyle(
                              color: getblackOpacity(.8),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                            decoration: InputDecoration(
                                // enabled: false,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: getblackOpacity(.3),
                                  ),
                                ),
                                fillColor: Colors.white,
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {});
                                    FocusScope.of(context)
                                        .requestFocus(_focusNode);
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: getblackOpacity(.3),
                                    size: 22,
                                  ),
                                )),
                            validator: (value) {
                              if (value == null) {
                                return "Input field required";
                              } else {
                                if (value.isEmpty) {
                                  return "Input field required";
                                } else {
                                  return null;
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 112,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                            text: "Wall Image: ",
                            size: 24,
                            color: getblackOpacity(.8),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              '$api/uploads/${details['banner']}',
                              width: 219,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          )
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
                              ? NewWallImageUpload(
                                  onPress: () {
                                    selectWallImage();
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
                      )
                    ],
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
                editWall();
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
