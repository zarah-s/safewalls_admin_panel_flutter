import 'package:flutter/material.dart';
import 'package:flutter_demo/common/actions/show_dropdown.dart';
import 'package:flutter_demo/common/button/new_button.dart';
import 'package:flutter_demo/common/inputs/search_input.dart';
import 'package:flutter_demo/common/typography/text_widget.dart';
import 'package:flutter_demo/features/walls/widgets/wall_image.dart';
import 'package:flutter_demo/services/provider.dart';
import 'package:flutter_demo/utils/colors.dart';

class Walls extends StatefulWidget {
  const Walls({
    Key? key,
    required this.onCreate,
    required this.onPressWall,
    required this.walls,
    required this.provider,
    required this.onActivate,
    required this.onDelete,
    required this.onSuspend,
  }) : super(key: key);
  final VoidCallback onCreate;
  final Function(String) onPressWall;
  final Provider provider;
  final List walls;
  final Function(Map) onDelete;
  final Function(String) onSuspend;
  final Function(String) onActivate;

  @override
  State<Walls> createState() => _WallsState();
}

class _WallsState extends State<Walls> {
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
        List search = short.walls
            .where((field) => field['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
        searched = search;
      });
    }
  }

  void toggleNumPerPage(value) {
    setState(() {
      numPerPage = value;
    });
  }

  @override
  void initState() {
    super.initState();

    numPerPage = counts[0];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: LayoutBuilder(
          builder: (context, constraints) {
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
                      text: "WALLS",
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
                        // ActionButton(
                        //     onPress: () {}, color: red, icon: Icons.delete)
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
                      text: "Create",
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
                    runSpacing: 54,
                    // runAlignment: WrapAlignment.spaceBetween,
                    children: searched.isNotEmpty
                        ? searched
                            .map(
                              (e) => WallImage(
                                onActivate: (data) {
                                  widget.onActivate(data);
                                },
                                onDelete: (Map data) {
                                  widget.onDelete(data);
                                },
                                onSuspend: (data) {
                                  widget.onSuspend(data);
                                },
                                details: e,
                                width: (constraints.maxWidth / 3) - 10,
                                onPress: widget.onPressWall,
                              ),
                            )
                            .toList()
                        : widget.walls.reversed
                            .toList()
                            .getRange(
                                0,
                                numPerPage == 'all'
                                    ? widget.walls.length
                                    : int.parse(numPerPage) >
                                            widget.walls.length
                                        ? widget.walls.length
                                        : int.parse(numPerPage))
                            .toList()
                            .map(
                              (e) => WallImage(
                                onActivate: (data) {
                                  widget.onActivate(data);
                                },
                                onDelete: (data) {
                                  widget.onDelete(data);
                                },
                                onSuspend: (data) {
                                  widget.onSuspend(data);
                                },
                                details: e,
                                width: (constraints.maxWidth / 3) - 10,
                                onPress: widget.onPressWall,
                              ),
                            )
                            .toList(),
                  ),
                ),
                const SizedBox(
                  height: 100,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
