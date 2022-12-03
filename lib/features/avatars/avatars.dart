// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/show_dropdown.dart';
import 'package:flutter_demo/common/button/action_button.dart';
import 'package:flutter_demo/common/button/new_button.dart';
import 'package:flutter_demo/common/flushbar/show_flushbar.dart';
import 'package:flutter_demo/common/inputs/search_input.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/features/avatars/widgets/avatar_image.dart';
import 'package:flutter_demo/services/post_request.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';
import 'package:get/get.dart';

class Avatars extends StatefulWidget {
  const Avatars(
      {Key? key,
      required this.onCreate,
      required this.provider,
      required this.avatars})
      : super(key: key);
  final VoidCallback onCreate;
  final Provider provider;
  final List avatars;

  @override
  State<Avatars> createState() => _AvatarsState();
}

class _AvatarsState extends State<Avatars> {
  final List _selecteds = [];
  List searched = [];
  List<String> counts = ['10', '50', '100', 'all'];
  late String numPerPage;

  onSearch(String query) {
    var short = widget.provider.apiData;

    if (query.isEmpty) {
      setState(() {
        searched = [];
      });
    } else {
      setState(() {
        List search = short.avatars
            .where((field) => field['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        searched = search;
      });
    }
  }

  Future<void> onDelete() async {
    if (_selecteds.isEmpty) {
      showFlushbar(
        widget.provider,
        "select item",
        context,
        success: false,
      );
    } else {
      if (widget.provider.apiData.avatars.length == 1 ||
          widget.provider.apiData.avatars.length == _selecteds.length) {
        showFlushbar(
          widget.provider,
          "Cannot delete all avatars",
          context,
        );
      } else {
        showFlushbar(widget.provider, "Deleting...", context, static: true);

        var res =
            await ApiRequest(data: {'data': _selecteds}, route: 'deleteAvatar')
                .postRequest();

        if (res['success']) {
          Get.back(closeOverlays: true);

          showFlushbar(
            widget.provider,
            "Success",
            context,
          );
        } else {
          Get.back(closeOverlays: true);

          showFlushbar(widget.provider, res['msg'], context, success: false);
        }
      }
    }
  }

  void toggleSelection(Map data) {
    int index = _selecteds.indexWhere((element) => element['id'] == data['id']);

    if (index == -1) {
      setState(() {
        _selecteds.add(data);
      });
    } else {
      setState(() {
        _selecteds.removeAt(index);
      });
    }
  }

  void toggleNumPerPage(value) {
    setState(() {
      numPerPage = value;
    });
    // if (value == "all") {
    //   // setState(() {
    //   //   avatars = short.avatars.reversed.toList();
    //   // });
    // } else {
    //   // setState(() {
    //   //   avatars = short.avatars.reversed
    //   //       .toList()
    //   //       .getRange(
    //   //           0,
    //   //           short.avatars.length < int.parse(value)
    //   //               ? short.avatars.length
    //   //               : int.parse(value))
    //   //       .toList();
    //   // });
    // }
  }

  @override
  void initState() {
    super.initState();

    numPerPage = counts[0];
  }

  @override
  Widget build(BuildContext context) {
    // List avatars = widget.provider.apiData.avatars;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: LayoutBuilder(builder: (context, constraint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 71,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextWidget(
                    text: "Avatars",
                    size: 40,
                    fontWeight: FontWeight.w700,
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: "Show",
                        size: 32,
                        color: getblackOpacity(.5),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      ShowDropdown(
                        initial: numPerPage,
                        items: counts,
                        onChange: toggleNumPerPage,
                      ),
                      const SizedBox(
                        width: 40,
                      ),
                      ActionButton(
                        onPress: () {
                          onDelete();
                        },
                        color: red,
                        icon: Icons.delete,
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 55,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  NewButton(
                    text: "Add",
                    onTap: () {
                      widget.onCreate();
                    },
                  ),
                  SearchInput(onChanged: onSearch),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  // spacing: 10,
                  runSpacing: 39,
                  children: searched.isNotEmpty
                      ? searched.map(
                          (e) {
                            bool isSelected = _selecteds
                                .where((element) => element['id'] == e['id'])
                                .isNotEmpty;
                            return InkWell(
                              onTap: () {
                                toggleSelection(e);
                              },
                              child: Stack(
                                children: [
                                  AvatarImage(
                                    details: e,
                                    width: (constraint.maxWidth / 4) - 10,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Checkbox(
                                        value: isSelected,
                                        onChanged: (_) {
                                          toggleSelection(e);
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        ).toList()
                      : widget.avatars.reversed
                          .toList()
                          .getRange(
                              0,
                              numPerPage == 'all'
                                  ? widget.avatars.length
                                  : int.parse(numPerPage) >
                                          widget.avatars.length
                                      ? widget.avatars.length
                                      : int.parse(numPerPage))
                          .toList()
                          .map(
                          (e) {
                            bool isSelected = _selecteds
                                .where((element) => element['id'] == e['id'])
                                .isNotEmpty;
                            return InkWell(
                              onTap: () {
                                toggleSelection(e);
                              },
                              child: Stack(
                                children: [
                                  AvatarImage(
                                    details: e,
                                    width: (constraint.maxWidth / 4) - 10,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: Checkbox(
                                        value: isSelected,
                                        onChanged: (_) {
                                          toggleSelection(e);
                                        }),
                                  )
                                ],
                              ),
                            );
                          },
                        ).toList(),
                ),
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          );
        }),
      ),
    );
  }
}
